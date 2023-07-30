import json
import re
import time
from pathlib import Path
from pprint import pprint
import pandas as pd

replace = (
    "[left-side-of-疑]",
    "png",
    "[right-side-of-疑]",
    "[𠤕]-s",
    "[コ]",
    "[丨-over-目]",
    "[丯-广]",
    "[丶-over-罒-口]",
    "[丹-丶]",
    "[𠂤-丿]",
    "[丿+𠃌]",
    "[乎-丁]",
    "[九+力]",
    "[乾-乙]",
    "[乾-乙+目]",
    "[亂-乚-爫-又-冂]",
    "[亮-儿]",
    "[亯-over-京]",
    "[㑴-亻]",
    "[亼+曰]",
    "[以-人]",
    "[伤-亻]",
    "[余-一]",
    "[侯-亻]",
    "[候-亻]",
    "[做-乍的異體]",
    "[傷-亻]",
    "[光-儿]",
    "[兜-皃]",
    "[具-目]",
    "[冬-夂]",
    "[処-几]",
    "[制-刂]",
    "[前-刂]",
    "[劉-刂]",
    "[勿-丿丿]",
    "[匀-勹]",
    "[北-匕]",
    "[卬-卩]",
    "[印-卩]",
    "[即-卩]",
    "[厨-厂]",
    "[厳-敢]",
    "[𠬤-又]",
    "[发-又]",
    "[变-又]",
    "[叚-又]",
    "[叟-又]",
    "[只-口]",
    "[可-口]",
    "[司-口]",
    "[同-口]",
    "[向-口]",
    "[呆-八]",
    "[周-口]",
    "[啬-回]",
    "[喦-over-人]",
    "[嗇-回]",
    "[嚴-敢]",
    "[囊-襄-亠]",
    "[図-囗]",
    "[𡌥-土]",
    "[在-土]",
    "[塁-土]",
    "[塩-口]",
    "[売-士]",
    "[壳-几]",
    "[复-夊]",
    "[夢-夕]",
    "[奖-大]",
    "[奥-向-口]",
    "[奧-向-口]",
    "[学-子]",
    "[𡨄-宀]",
    "[実-宀]",
    "[害-口]",
    "[容-穴]",
    "[寒-𡨄]",
    "[寒-宀-二]",
    "[寧-宀-心]",
    "[将-寸]",
    "[尢+力]",
    "[尭-兀]",
    "[展-尸]",
    "[屬-蜀]",
    "[屮+口]",
    "[岡-山]",
    "[州-川]",
    "[巣-木]",
    "[𢀖-工]",
    "[巨-over-木]",
    "[差-左]",
    "[师-帀]",
    "[希-巾]",
    "[㡭-幺]",
    "[度-又]",
    "[庶-灬]",
    "[延-廴]",
    "[弗-弓]",
    "[彙-果]",
    "[㣎-彡]",
    "[従-彳]",
    "[徳-彳]",
    "[徴-彳-攵]",
    "[徵-彳-攵]",
    "[徹-彳]",
    "[愛-心-夊]",
    "[慶-心]",
    "[憂-心]",
    "[懐-忄]",
    "[或-戈]",
    "[拜-手]",
    "[捜-扌]",
    "[揺-扌]",
    "[搖-扌]",
    "[摂-扌]",
    "[敖-攵]",
    "[断-斤]",
    "[於-㫃]",
    "[旁-方]",
    "[旅-㫃]",
    "[既-旡]",
    "[𣃧-日]",
    "[㬎-日]",
    "[昜-日]",
    "[晉-日]",
    "[晋-日]",
    "[暴-氺]",
    "[𣃧-曰+目]",
    "[曹-曰]",
    "[會-𡆧]",
    "[望-亡-𡈼]",
    "[桜-木]",
    "[棄-ㄊ]",
    "[楕-木]",
    "[款-欠]",
    "[止-over-又]",
    "[武-止]",
    "[歯-止]",
    "[歳-止]",
    "[段-殳]",
    "[氵+刅]",
    "[氺-丨]",
    "[涩-氵]",
    "[渇-氵]",
    "[渋-氵]",
    "[渓-氵]",
    "[満-氵]",
    "[满-氵]",
    "[漢-氵]",
    "[灰-火]",
    "[灲-刂]",
    "[炙-火]",
    "[炼-火]",
    "[無-灬]",
    "[爭-爫]",
    "[爭-爫-丨]",
    "[獣-犬]",
    "[琐-玉]",
    "[產-生]",
    "[留-田]",
    "[畢-田]",
    "[疑-𠤕]",
    "[発-癶]",
    "[發-又]",
    "[益-皿]",
    "[盐-卜]",
    "[监-𠂉丶皿]",
    "[监-皿]",
    "[盡-皿]",
    "[直-十]",
    "[盾-丨-目]",
    "[盾-目]",
    "[看-目]",
    "[着-目]",
    "[竟-立]",
    "[籖-𥫗]",
    "[粤-丂]",
    "[粵-丂]",
    "[索-糸]",
    "[紧-糸]",
    "[縁-糹]",
    "[练-纟]",
    "[罕-干]",
    "[罰-言]",
    "[而-over-天]",
    "[肃-肀]",
    "[肈-聿]",
    "[脊-月]",
    "[脳-月]",
    "[臼-over-土]",
    "[臼-over-工]",
    "[舉-與]",
    "[舍-口]",
    "[舎-口]",
    "[舜-夗]",
    "[艸+口]",
    "[芻-屮]",
    "[茶-艹]",
    "[荡-氵]",
    "[莺-乌]",
    "[華-艹]",
    "[萨-艹]",
    "[蔑-戍]",
    "[蔵-艹]",
    "[虐-虍]",
    "[虛-虍]",
    "[表-衣]",
    "[衰-衣]",
    "[裏-里]",
    "[覧-見]",
    "[観-見]",
    "[覽-見]",
    "[言-口]",
    "[訁-口]",
    "[譲-言]",
    "[谷-口]",
    "[豆+寸]",
    "[豕+肩]",
    "[賊-戈]",
    "[賓-宀-貝k]",
    "[賓-宀-貝]",
    "[贼-戈]",
    "[辛+殳]",
    "[辶+冎]",
    "[辶+各]",
    "[逓-辶]",
    "[過-口]",
    "[那-⻏]",
    "[郎-⻏]",
    "[鉴-金]",
    "[锁-钅]",
    "[陋-阝]",
    "[陥-⻖]",
    "[陥-阝]",
    "[隋-⻖]",
    "[隠-⻖]",
    "[隠-阝]",
    "[雜-朩-隹]",
    "[雨-一]",
    "[霊-亚]",
    "[韋-囗]",
    "[馋-饣]",
    "[騒-馬]",
    "[高-口]",
    "[鬱-鬯]",
    "[鸟-一]",
    "[鹽-鹵]",
    "[齐-文]",
    "[齿-止]",
    "[龍-𦚏-三]",
)

with open("outlier.json") as f:
    d = json.load(f)

i = 0


for e in d:
    # print("\n\n\n" + str(i))

    if e["ancient_form_svg_file_path"]:
        p = Path(e["ancient_form_svg_file_path"]).name
        e["ancient_form_svg_file_path"] = (
            '<img src="' + p + '"/>'
        )  # re.sub('\[(essentials|expert)_data\]','<img src=\'', e['ancient_form_svg_file_path']) + '\'/>'
        # print(e['ancient_form_svg_file_path'])

    if e["component_analyses"]:
        e["component_analyses"] = e["component_analyses"].replace("|||", "<br/>\n")
        e["component_analyses"] = re.sub(
            "(\.\././|\.\./\.\./\.\./(references|key\-concepts(-kanji)?))",
            "",
            e["component_analyses"],
        )
        e["component_analyses"] = re.sub(
            "((^\[e|<file).*?/component>|<(/)?html>)",
            "",
            e["component_analyses"],
            flags=re.DOTALL,
        )
        if re.search(".\[.*?\]", e["component_analyses"]):
            for r in replace:
                e["component_analyses"] = e["component_analyses"].replace(
                    r, "<img src='" + r + ".svg'/>"
                )
        # print(e["component_analyses"])

    if e["expert_data_file_path"]:
        e["expert_data_file_path"] = re.sub(
            "\[(essentials|expert)_data\]", "", e["expert_data_file_path"]
        )
        p = Path(e["expert_data_file_path"]).name
        with open(e["expert_data_file_path"]) as f:
            h = f.read()
        e["expert_data_file_path"] = re.sub(
            "(\.\./(.{1,4}|key-concepts-kanji|references)/|\.\./\.\./\.\./(references|key-concepts(-kanji)?))",
            "",
            h,
        )
        # print(e['expert_data_file_path'])

    if e["form_explanation_file_path"]:
        e["form_explanation_file_path"] = re.sub(
            "\[(essentials|expert)_data\]", "", e["form_explanation_file_path"]
        )
        p = Path(e["form_explanation_file_path"]).name
        with open(e["form_explanation_file_path"]) as f:
            h = f.read()
        h = re.sub(
            "(\.\./(.|....)/|\.\./\.\./\.\./(references|key-concepts(-kanji)?))", "", h
        )
        h = (
            re.sub("^.*<body>", "", h, flags=re.DOTALL)
            .replace("</body>\n</html>", "")
            .strip()
        )
        e["form_explanation_file_path"] = (
            re.sub("<p>Ancient.*?</p>", "", h, flags=re.DOTALL)
            .replace('<header id="title-block-header">\n</header>', "")
            .strip()
        )
        if re.search(".\[.*?\]", e["form_explanation_file_path"]):
            for r in replace:
                e["form_explanation_file_path"] = e[
                    "form_explanation_file_path"
                ].replace(r, "<img src='" + r + ".svg'/>")
        # print(e['form_explanation_file_path'])

    if e["meaning_tree_character_meanings"]:
        e["meaning_tree_character_meanings"] = re.sub(
            "(\.\././|\.\./\.\./\.\./(references|key-concepts(-kanji)?))",
            "",
            e["meaning_tree_character_meanings"],
        )

    if e["meaning_tree_component_meanings"]:
        e["meaning_tree_component_meanings"] = re.sub(
            "(\.\././|\.\./\.\./\.\./(references|key-concepts(-kanji)?))",
            "",
            e["meaning_tree_component_meanings"],
        )

    if e["meaning_tree_kun_vocabulary"]:
        e["meaning_tree_kun_vocabulary"] = e["meaning_tree_kun_vocabulary"].replace(
            "|||", "</br>"
        )

    if e["meaning_tree_level_info"]:
        e["meaning_tree_level_info"] = e["meaning_tree_level_info"].replace(
            "|||", "</br>"
        )

    if e["meaning_tree_on_vocabulary"]:
        e["meaning_tree_on_vocabulary"] = e["meaning_tree_on_vocabulary"].replace(
            "|||", "</br>"
        )

    if e["svgs_for_components_without_an_NCR_file_path"]:
        e["svgs_for_components_without_an_NCR_file_path"] = (
            "<img src='"
            + Path(e["svgs_for_components_without_an_NCR_file_path"]).name
            + "'/>"
        )
        # print(e['svgs_for_components_without_an_NCR_file_path'])

    if e["system_data_file_path"]:
        with open(e["system_data_file_path"]) as f:
            h = f.read()
        h = h.split("\n", 8)[8].replace("</body></html>", "")
        e["system_data_file_path"] = re.sub(
            "(\.\././|\.\./\.\./\.\./(references|key-concepts(-kanji)?))", "", h
        )
        # print(e['system_data_file_path'])

    i = i + 1

df = pd.json_normalize(d)
df.insert(0, "kanji", df.pop("kanji"))
df.columns = [
    "kanji",
    "ancient-form",
    "component-analyses",
    "expert-data",
    "form-explanation",
    "character-meanings",
    "component-meanings",
    "kunyomi",
    "kunyomi-vocab",
    "level-info",
    "onyomi",
    "onyomi-vocab",
    "svg",
    "system-data",
]
df = df.assign(tags="outlier")

with open("kj.json") as f:
    kj = pd.json_normalize(json.load(f))
kj.columns = [
    "kj_keyword",
    "onyomi",
    "kunyomi",
    "kj_meaning",
    "kanji",
    "variantOf",
    "kj_tags",
]
kj = kj.assign(tags="kanjijump")
# dfi = df.set_index(["kanji"]).index
# kji = kj.set_index(["kanji"]).index
# mask = ~kji.isin(dfi)
# result = kj.loc[mask]
df = df.merge(kj, how="outer", on="kanji", suffixes=["_out", "_kj"])
df["kj_meaning"] = "<ol><li>" + df["kj_meaning"].str.join("</li><li>") + "</li></ol>"

rtk = pd.read_csv(
    "rtk.txt",
    usecols=[0, 2, 6, 11, 12, 13, 14, 15],
    delimiter="\t",
    header=None,
    names=["kanji", "rtk_keyword", "index", "m1", "m2", "m3", "m4", "m5"],
    dtype={"index": "Int32"},
)
rtk = rtk.assign(tags_rtk="rtk")
df = df.merge(rtk, how="outer", on="kanji")
df = df.sort_values("index", ascending=True)

df["keyword"] = df["kj_keyword"].fillna(df["rtk_keyword"])
df["onyomi"] = df["onyomi_out"].fillna(df["onyomi_kj"])  # .fillna(df['onyomi_rtk'])
df["kunyomi"] = df["kunyomi_out"].fillna(df["kunyomi_kj"])  # .fillna(df['kunyomi_rtk'])
df["reading"] = df["onyomi"].fillna(df["kunyomi"])
cols = ["character-meanings", "component-meanings"]
df["meaning"] = df[cols].apply(
    lambda x: None if x.isnull().all() else "".join(x.dropna()), axis=1
)
df["meaning"] = df["meaning"].fillna(df["kj_meaning"])
df["mnemonic"] = df.apply(
    lambda row: ""
    if row[["m1", "m2", "m3", "m4", "m5"]].isnull().all()
    else (
        "<ol><li>"
        + "</li><li>".join(
            [str(val) for val in row[["m1", "m2", "m3", "m4", "m5"]] if pd.notnull(val)]
        )
        + "</li></ol>"
    ),
    axis=1,
)

df = df.rename(columns={"index": "rtk-number"})
cols = ["tags_out", "tags_kj", "tags_rtk", "kj_tags"]
df["tags"] = df[cols].apply(
    lambda x: None if x.isnull().all() else " ".join(x.dropna()), axis=1
)

# df.drop(
#     columns=[
#         "kunyomi",
#         "kunyomi_out",
#         "kunyomi_kj",
#         "onyomi",
#         "onyomi_out",
#         "onyomi_kj",
#         "kunyomi-vocab",
#         "onyomi-vocab",
#         "character-meanings",
#         "component-meanings",
#         "kj_meaning",
#         "level-info",
#         "tags_out",
#         "tags_kj",
#     ],
#     inplace=True,
# )

output = df[
    [
        "kanji",
        "reading",
        "meaning",
        "keyword",
        "mnemonic",
        "component-analyses",
        "ancient-form",
        "form-explanation",
        "expert-data",
        "system-data",
        "variantOf",
        "rtk-number",
        "svg",
        "tags",
    ]
]
output.to_csv("ertk3.csv", header=False, index=False, encoding="utf-8", sep="|")


# c = json.loads(df.to_json(orient="records"))
# d = []
# out = []
# for cc in c:
#     d.append(cc["kanji"])
#     # print(str(cc["index"]) + "\t" + cc["kanji"])
#     if cc["component-analyses"]:
#         print("Components of " + cc["kanji"])
#         cd = re.sub("<a href=.*?>Reference", "", cc["component-analyses"])
#         ce = re.sub(
#             f"à|ā|‘|ǐ|ò|{cc['kanji']}|“|【|】|’|、|”|[ァ-ン]",
#             "",
#             "".join(e for e in cd if ord(e) >= 128),
#         )

#         dif = set(ce) - set(d)
#         if dif:
#             print(dif)
#             d = d + list(dif)
#     out.append(cc)
#     # r = re.findall("In .*?, (.*?) ", cc["component-analyses"])
#     # if not r:
#     #     print("Components of " + cc["kanji"])
#     #     print("ohno")
#     # if r:
#     #     print(r)
#     #     print("---------")
#     time.sleep(0.075)
