#!/usr/bin/env python3
# check-i18n.py — 校验 i18n/*.sh 与内置英文基准的一致性
#
# 检查两件事：
#   1. 每个语言包是否覆盖了全部 M_* key（缺的会在运行时回落英文，但说明该补了）
#   2. 每条消息的 %s 占位符数量是否与英文一致（不一致会导致 printf 少参/吞参）
#
# 用法：python3 scripts/check-i18n.py      退出码 0 = 全通过
import glob
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MAIN = os.path.join(ROOT, "bin", "agent-safe-input")
I18N = os.path.join(ROOT, "i18n")


def parse(text):
    return {m.group(1): m.group(2) for m in re.finditer(r"^\s*(M_[A-Z0-9_]+)=(.*)$", text, re.M)}


def placeholders(value):
    # %% 是字面百分号，不算占位符
    return len(re.findall(r"(?<!%)%s", value))


def main():
    with open(MAIN, encoding="utf-8") as f:
        src = f.read()
    try:
        en_block = src.split("lang_en() {")[1].split("\n}")[0]
    except IndexError:
        print("cannot locate lang_en() in bin/agent-safe-input", file=sys.stderr)
        return 2

    en = parse(en_block)
    packs = sorted(glob.glob(os.path.join(I18N, "*.sh")))
    if not packs:
        print("no language packs found in i18n/", file=sys.stderr)
        return 2

    issues = 0
    seen = {"en"}
    for path in packs:
        tag = os.path.basename(path)[:-3]
        if tag in seen:
            print(f"DUPLICATE tag {tag} (en is built in)")
            issues += 1
        seen.add(tag)
        with open(path, encoding="utf-8") as f:
            pack = parse(f.read())
        for key, value in en.items():
            if key not in pack:
                # 缺 key 会回落英文，严格说不是错误；提示一下即可
                print(f"WARN missing   {tag}: {key}")
                continue
            if placeholders(value) != placeholders(pack[key]):
                print(
                    f"FAIL placeholder {tag}: {key} "
                    f"en={placeholders(value)} got={placeholders(pack[key])}"
                )
                issues += 1

    print(f"languages={len(packs)} (+1 built-in) keys={len(en)} issues={issues}")
    return 1 if issues else 0


if __name__ == "__main__":
    sys.exit(main())
