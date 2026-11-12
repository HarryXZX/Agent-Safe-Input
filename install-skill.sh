#!/usr/bin/env bash
# install-skill.sh — install the Agent-Safe-Input skill into AI agent directories
#
# 一个 SKILL.md，装进不同 agent 的 skills 目录；对只读 AGENTS.md 的工具给出说明。
#
# 用法：
#   ./install-skill.sh                 自动探测本机已存在的 agent，逐个安装（用户级）
#   ./install-skill.sh claude          只装 Claude Code
#   ./install-skill.sh claude workbuddy
#   ./install-skill.sh openclaw        只装 OpenClaw（社区昵称「龙虾」），落 ~/.openclaw/skills/
#   ./install-skill.sh -p . cursor     装到当前项目的 .cursor/rules/
#   ./install-skill.sh --list          看支持哪些 target、探测到什么
#   ./install-skill.sh -f workbuddy    覆盖已有安装
#   ./install-skill.sh --uninstall claude
# 许可：MIT
# =============================================================================
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SRC="$ROOT/skills/agent-safe-input"
NAME="agent-safe-input"
VERSION="$(sed -n 's/^  version:[[:space:]]*"\{0,1\}\([0-9][0-9.]*\)"\{0,1\}[[:space:]]*$/\1/p' "$SKILL_SRC/SKILL.md" 2>/dev/null | head -1)"
[ -n "$VERSION" ] || VERSION="unknown"

die()  { printf 'install-skill: %s\n' "$*" >&2; exit 1; }
warn() { printf 'install-skill: %s\n' "$*" >&2; }
info() { printf 'install-skill: %s\n' "$*" >&2; }

[ -f "$SKILL_SRC/SKILL.md" ] || die "找不到 $SKILL_SRC/SKILL.md（请在仓库根目录运行本脚本）"

usage() {
    sed -n '2,16p' "$0" | sed 's/^# \{0,1\}//'
}

# ── 各 agent 的落点 ──────────────────────────────────────────────────────────
# Windows 风格的 C:\Users\x 在 Git Bash 里会被安全钩子拦截（盘符前缀），统一转成 /c/Users/x
norm_path() {
    local p="$1"
    case "$p" in
        [A-Za-z]:[\\/]*)
            local drive rest
            drive="$(printf '%s' "${p%%:*}" | tr 'A-Z' 'a-z')"
            rest="${p#*:}"; rest="${rest//\\//}"
            printf '/%s%s' "$drive" "$rest"
            ;;
        *) printf '%s' "$p" ;;
    esac
}

# 用户级目录（$HOME 下）；项目级 = <project>/<相对路径>
user_claude()    { norm_path "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills/$NAME"; }
user_workbuddy() { norm_path "${WORKBUDDY_CONFIG_DIR:-$HOME/.workbuddy}/skills/$NAME"; }
# OpenClaw（「龙虾」）遵循 AgentSkills 规范，全局安装落在 <state-dir>/skills
user_openclaw()  { norm_path "${OPENCLAW_STATE_DIR:-$HOME/.openclaw}/skills/$NAME"; }

probe_target() {
    case "$1" in
        claude)    [ -d "$(norm_path "${CLAUDE_CONFIG_DIR:-$HOME/.claude}")" ] && echo "已安装客户端" || echo "未检测到" ;;
        workbuddy) [ -d "$(norm_path "${WORKBUDDY_CONFIG_DIR:-$HOME/.workbuddy}")" ] && echo "已安装客户端" || echo "未检测到" ;;
        openclaw)  [ -d "$(norm_path "${OPENCLAW_STATE_DIR:-$HOME/.openclaw}")" ] && echo "已安装客户端" || echo "未检测到" ;;
        cursor)    [ -d ".cursor" ] && echo "当前目录有 .cursor/" || echo "未检测到（项目级安装即可）" ;;
        agents)    [ -f "AGENTS.md" ] && echo "当前目录有 AGENTS.md" || echo "读仓库根的 AGENTS.md" ;;
        *)         echo "未知" ;;
    esac
}

list_targets() {
    printf '\n%-12s %-10s %s\n' "TARGET" "级别" "落点"
    printf '%s\n' "---------------------------------------------------------------"
    printf '%-12s %-10s %s\n' "claude"    "用户/项目" "~/.claude/skills/$NAME/SKILL.md"
    printf '%-12s %-10s %s\n' "workbuddy" "用户/项目" "~/.workbuddy/skills/$NAME/SKILL.md"
    printf '%-12s %-10s %s\n' "openclaw"  "用户"      "~/.openclaw/skills/$NAME/SKILL.md"
    printf '%-12s %-10s %s\n' "cursor"    "项目"      ".cursor/rules/$NAME.mdc"
    printf '%-12s %-10s %s\n' "agents"    "—"         "无需安装，codex/gemini/copilot 直接读 AGENTS.md"
    printf '\n探测结果：\n'
    local t
    for t in claude workbuddy openclaw cursor agents; do
        printf '  %-10s %s\n' "$t" "$(probe_target "$t")"
    done
    printf '\n'
}

# ── 安装 / 卸载 ──────────────────────────────────────────────────────────────
verify_frontmatter() {   # $1 = 装好的 SKILL.md
    local n
    n="$(sed -n 's/^name:[[:space:]]*//p' "$1" | head -1 | tr -d '"'"'"' \r')"
    [ "$n" = "$NAME" ] || die "$1 的 name 字段是 '$n'，期望 '$NAME'（规范要求与目录同名）"
}

do_install_dir() {   # $1 = 目标 skill 目录
    local dest="$1"
    if [ -e "$dest/SKILL.md" ] && [ "$FORCE" -ne 1 ]; then
        if cmp -s "$SKILL_SRC/SKILL.md" "$dest/SKILL.md"; then
            info "✔ 已是最新：$dest/SKILL.md"
            return 0
        fi
        warn "已存在且内容不同：$dest/SKILL.md（加 -f 覆盖）"
        return 3
    fi
    if [ "$DRY" -eq 1 ]; then
        info "[dry-run] mkdir -p $dest && cp SKILL.md → $dest/SKILL.md"
        return 0
    fi
    mkdir -p "$dest" || die "无法创建 $dest"
    cp "$SKILL_SRC/SKILL.md" "$dest/SKILL.md" || die "复制失败：$dest"
    verify_frontmatter "$dest/SKILL.md"
    info "✔ $dest/SKILL.md"
}

do_install_cursor() {   # $1 = 项目目录
    local dest="$1/.cursor/rules/$NAME.mdc"
    if [ -e "$dest" ] && [ "$FORCE" -ne 1 ]; then
        if cmp -s "$SKILL_SRC/cursor/$NAME.mdc" "$dest"; then
            info "✔ 已是最新：$dest"
            return 0
        fi
        warn "已存在且内容不同：$dest（加 -f 覆盖）"
        return 3
    fi
    if [ "$DRY" -eq 1 ]; then
        info "[dry-run] mkdir -p $1/.cursor/rules && cp cursor/$NAME.mdc → $dest"
        return 0
    fi
    mkdir -p "$(dirname "$dest")" || die "无法创建 $(dirname "$dest")"
    cp "$SKILL_SRC/cursor/$NAME.mdc" "$dest" || die "复制失败：$dest"
    info "✔ $dest"
}

do_uninstall() {
    local t="$1" dest=""
    case "$t" in
        claude)    dest="$(user_claude)" ;;
        workbuddy) dest="$(user_workbuddy)" ;;
        openclaw)  dest="$(user_openclaw)" ;;
        cursor)    dest="$PROJECT_DIR/.cursor/rules/$NAME.mdc" ;;
        agents)    info "agents 目标无需安装，也不卸载"; return 0 ;;
        *)         die "未知 target：$t" ;;
    esac
    # 只删本工具自己创建的路径，且必须含 skills/ 或 .cursor/rules
    case "$dest" in
        */skills/$NAME|*/.cursor/rules/$NAME.mdc) ;;
        *) die "拒绝删除可疑路径：$dest" ;;
    esac
    if [ -e "$dest" ]; then
        if [ "$DRY" -eq 1 ]; then
            info "[dry-run] 删除 $dest"
        elif [ -d "$dest" ]; then
            # 不用 rm -rf：只删自己放的 SKILL.md，目录空了才移除
            rm -f "$dest/SKILL.md"
            if rmdir "$dest" 2>/dev/null; then
                info "✔ 已移除 $dest"
            else
                warn "已删除 SKILL.md，但目录非空（你放进去的东西不动），保留：$dest"
            fi
        else
            rm -f "$dest" && info "✔ 已移除 $dest"
        fi
    else
        info "未安装：$dest"
    fi
}

# ── 参数 ─────────────────────────────────────────────────────────────────────
MODE="user"; PROJECT_DIR="."; FORCE=0; DRY=0; ACTION="install"
TARGETS=()

while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)    usage; exit 0 ;;
        -l|--list)    list_targets; exit 0 ;;
        -u|--user)    MODE="user"; shift ;;
        -p|--project) MODE="project"; PROJECT_DIR="${2:-.}"; [ $# -ge 2 ] && shift 2 || shift ;;
        -f|--force)   FORCE=1; shift ;;
        -n|--dry-run) DRY=1; shift ;;
        --uninstall)  ACTION="uninstall"; shift ;;
        -*)           die "未知选项：$1（试 --help）" ;;
        *)            TARGETS+=("$1"); shift ;;
    esac
done

PROJECT_DIR="$(norm_path "$PROJECT_DIR")"

# 默认：探测已存在的客户端
if [ ${#TARGETS[@]} -eq 0 ]; then
    [ -d "$(norm_path "${CLAUDE_CONFIG_DIR:-$HOME/.claude}")" ] && TARGETS+=("claude")
    [ -d "$(norm_path "${WORKBUDDY_CONFIG_DIR:-$HOME/.workbuddy}")" ] && TARGETS+=("workbuddy")
    [ -d "$(norm_path "${OPENCLAW_STATE_DIR:-$HOME/.openclaw}")" ] && TARGETS+=("openclaw")
    if [ ${#TARGETS[@]} -eq 0 ]; then
        warn "没有探测到已知的 agent 客户端目录"
        list_targets
        info "可以手动指定：./install-skill.sh claude  或  ./install-skill.sh -p . cursor"
        exit 1
    fi
    info "自动探测到：${TARGETS[*]}"
fi

rc=0
for t in "${TARGETS[@]}"; do
    if [ "$ACTION" = "uninstall" ]; then
        do_uninstall "$t"
        continue
    fi
    case "$t" in
        claude|workbuddy)
            if [ "$MODE" = "project" ]; then
                [ "$t" = "claude" ] && base="$PROJECT_DIR/.claude/skills/$NAME" || base="$PROJECT_DIR/.workbuddy/skills/$NAME"
            else
                [ "$t" = "claude" ] && base="$(user_claude)" || base="$(user_workbuddy)"
            fi
            do_install_dir "$base" || rc=$?
            ;;
        cursor)
            if [ "$MODE" = "user" ]; then
                info "cursor 只支持项目级，自动改用 -p $PROJECT_DIR"
            fi
            do_install_cursor "$PROJECT_DIR" || rc=$?
            ;;
        openclaw)
            if [ "$MODE" = "project" ]; then
                info "openclaw 只支持用户级（~/.openclaw/skills），忽略 -p"
            fi
            do_install_dir "$(user_openclaw)" || rc=$?
            ;;
        agents)
            info "agents：codex / gemini-cli / copilot 读仓库根的 AGENTS.md，无需安装"
            ;;
        *) die "未知 target：$t（--list 看可用项）" ;;
    esac
done

if [ "$ACTION" = "install" ]; then
    printf '\n'
    info "完成。验证方式：让 agent 读一次 skill 列表，或直接问它「装个包」看它是否会先排队而不是问你要密码。"
    info "卸载：./install-skill.sh --uninstall <target>"
fi
exit $rc
