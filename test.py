from PIL import Image

img = Image.open("highland_cow.jpg")
# Saving with quality ~75-80 will easily bring a standard JPEG under 1MB
img.save("highland_cow_compressed.jpg", "JPEG", optimize=True, quality=80)