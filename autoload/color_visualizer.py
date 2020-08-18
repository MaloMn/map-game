import re
import numpy as np
import PIL
from PIL import Image

with open("Colors.gd") as f:
	file = f.read()

colors = re.findall(r"#[0-9a-f]{3,6}", file)
colors = list(set(colors))

images = [Image.new('RGB', (150, 150), color=c) for c in colors]
images_comb = np.hstack([np.asarray(i) for i in images])
images_comb = PIL.Image.fromarray(images_comb)
images_comb.save("colors.png")
