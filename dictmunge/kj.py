import pandas as pd
import json, copy, time
from pprint import pprint

with open("components.json") as f:
    a = json.load(f)
    b = []
    for c in a["props"]["pageProps"]["componentsByUsesCount"]:
        for d in c["components"]:
            b.append(d)
    s = pd.json_normalize(b)
    compc = json.loads(s.to_json(orient="records"))
    components = []
    seen = []
    for cc in compc:
        if cc["mainBadgeProps.mainKey"] not in seen:
            seen.append(cc["mainBadgeProps.mainKey"])
            components.append(
                {
                    "keyword": cc["keyword"].replace("*", ""),
                    "onyomi": cc["soundMarkValue"],
                    "kunyomi": None,
                    "meaning": None,
                    "kanji": cc["mainBadgeProps.mainKey"],
                    "variantOf": None,
                    "tag": "component-only",
                }
            )
        if cc["variantsBadgeProps"]:
            for ccc in cc["variantsBadgeProps"]:
                seen.append(ccc["figureKey"])
                if ccc["figureKey"] not in seen:
                    components.append(
                        {
                            "keyword": cc["keyword"],
                            "onyomi": cc["soundMarkValue"],
                            "kunyomi": None,
                            "meaning": None,
                            "kanji": ccc["figureKey"],
                            "variantOf": ccc["mainKey"],
                            "tag": "component-only variant",
                        }
                    )

with open("characters.json") as f:
    a = json.load(f)
    b = pd.json_normalize(a["props"]["pageProps"]["importantCharacters"])
    c = json.loads(b.to_json(orient="records"))
    characters = []
    for cc in c:
        on = cc["readings.kanjidicOn"]
        if type(on) == list:
            on = str.join("、", on)
        kun = cc["readings.kanjidicKun"]
        if type(kun) == list:
            kun = str.join("、", kun)
        characters.append(
            {
                "keyword": cc["mnemonic.mnemonic"],
                "onyomi": on,
                "kunyomi": kun,
                "meaning": cc["readings.kanjidicMeaning"],
                "kanji": cc["key"],
                "variantOf": None,
                "tag": "character",
            }
        )
        if cc["secondaryVariants"]:
            for ccc in cc["secondaryVariants"]:
                characters.append(
                    {
                        "keyword": cc["mnemonic.mnemonic"],
                        "onyomi": on,
                        "kunyomi": kun,
                        "meaning": cc["readings.kanjidicMeaning"],
                        "kanji": ccc,
                        "variantOf": cc["key"],
                        "tag": "character variant",
                    }
                )
    for d in characters:
        if (not d["keyword"]) and (not d["onyomi"]) and (not d["meaning"]):
            d["tag"] = "missing"

result = copy.deepcopy(characters)
for g in components:
    for h in characters:
        if g["kanji"] == h["kanji"]:
            break
    else:
        result.append(g)
with open("kj.json", "w") as f:
    f.write(json.dumps(result))
