from pathlib import Path

from PIL import Image, ImageDraw, ImageFont, ImageOps


ROOT = Path(__file__).resolve().parents[1]
STREAMERS = ROOT / "art" / "references" / "streamers"
BILI = ROOT / "art" / "references" / "bilibili"

CELL_W, CELL_H = 280, 320
PHOTO = (250, 250)


def crop(path: Path, box=None) -> Image.Image:
    im = Image.open(path).convert("RGB")
    if box is not None:
        im = im.crop(box)
    return ImageOps.fit(im, PHOTO, method=Image.Resampling.LANCZOS, centering=(0.5, 0.35))


def font(size: int):
    for path in [Path("C:/Windows/Fonts/msyh.ttc"), Path("C:/Windows/Fonts/simhei.ttf")]:
        if path.exists():
            return ImageFont.truetype(str(path), size)
    return ImageFont.load_default()


def make_board(name: str, entries):
    board = Image.new("RGB", (CELL_W * 5, CELL_H * 2), "#ead9b8")
    draw = ImageDraw.Draw(board)
    label_font = font(27)
    for i, (cid, cname, source, box) in enumerate(entries):
        x = (i % 5) * CELL_W
        y = (i // 5) * CELL_H
        photo = crop(source, box)
        board.paste(photo, (x + 15, y + 10))
        draw.rectangle((x + 14, y + 9, x + 266, y + 261), outline="#493224", width=3)
        label = f"{cid}  {cname}"
        bbox = draw.textbbox((0, 0), label, font=label_font)
        draw.text((x + (CELL_W - (bbox[2] - bbox[0])) / 2, y + 274), label,
                  fill="#24180f", font=label_font)
    out = STREAMERS / name
    board.save(out, quality=95)
    print(out)


def s(name):
    return STREAMERS / name


def b(name):
    return BILI / name


make_board("reference_board_A.png", [
    ("C01", "阿飞", s("C01_afei.jpg"), None),
    ("C02", "抹茶", s("C02_matcha.jpg"), None),
    ("C03", "王大谋", s("C03_wangdamou.jpg"), None),
    ("C04", "小酒瓶", s("C04_bottle.jpg"), None),
    ("C05", "李李", s("C05_lili.jpg"), None),
    ("C06", "余初九", s("C06_yuchujiu.jpg"), None),
    ("C07", "小月牙", s("C07_xiaoyueya.jpg"), None),
    ("C08", "小鱼贝壳", s("C08_shell.jpg"), None),
    ("C09", "白小帅子", s("C09_baixiaoshuai.jpg"), None),
    ("C10", "王怼怼", s("C10_wangduidui.jpg"), None),
])

make_board("reference_board_B.png", [
    ("C11", "川神", b("S19_C11_C12_BV1cJoyBqE67.jpg"), (35, 20, 295, 420)),
    ("C12", "小虎", b("S19_C11_C12_BV1cJoyBqE67.jpg"), (245, 20, 530, 420)),
    ("C13", "大鹅", s("224_tuanbo_S7_roster.jpg"), (250, 175, 390, 365)),
    ("C14", "小杰", s("C14_xiaojie.jpg"), None),
    ("C15", "苏袜", b("S22_C15_C17_BV1454R6iEVa.jpg"), (500, 170, 1010, 920)),
    ("C16", "涂涂", s("C16_tutu.jpg"), None),
    ("C17", "可可", b("S22_C15_C17_BV1454R6iEVa.jpg"), (1190, 130, 1760, 920)),
    ("C18", "童猪", s("C18_tongzhu.jpg"), None),
    ("C19", "奶盖", b("S25_C19_BV1ThtN6vEa7.jpg"), None),
    ("C20", "余想", b("S39_C20_BV1Qntq6hEwL.jpg"), None),
])

make_board("reference_board_C.png", [
    ("C21", "美伢", s("C21_meiya.jpg"), None),
    ("C22", "陈知含", s("C22_chenzhihan.jpg"), None),
    ("C23", "千涵", b("S42_C23_BV1tQ4R6gELW.jpg"), None),
    ("C25", "玩蛇", s("C25_wanshe.jpg"), None),
    ("C26", "芷芷", s("C26_zhizhi.jpg"), None),
    ("C27", "瑶瑶牙", b("S38_C27_BV1w1b36VEW6.jpg"), (980, 40, 1720, 1040)),
    ("C28", "羊咩咩", s("224_tuanbo_S7_roster.jpg"), (1315, 345, 1470, 555)),
    ("C29", "一凹瑶", s("C29_yiyaoyao.jpg"), None),
    ("C30", "罗一可", s("C30_luoyike.jpg"), None),
    ("C31", "bula", s("C31_bula.jpg"), None),
])
