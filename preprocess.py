import time
import os

MAX_CHAR_LENGTH = 512
MIN_CHAR_LENGTH = 256

NEW_LINE_CHAR = "<N>"

dataset_path = "dataset"
full_paths = []
for dirpath, dirnames, filenames in os.walk(dataset_path):
    for f in filenames:
        full_path = os.path.join(dirpath, f)
        full_paths.append(full_path)

print(len(full_paths))

print("Removing old dataset")
time.sleep(2)
try:
    os.remove("pascal_dataset_text_code.txt")
except Exception as e:
    print("Looks like there is no dataset skipping the deletion")

with open("pascal_dataset_text_code.txt", "a") as f:
    for fpath in full_paths:
        try:
            print(fpath)
            data = open(fpath, "rb").read().decode("utf-8")
            # print(data)
            fd = data.replace('\n', NEW_LINE_CHAR)

            if 100 < len(data) < MAX_CHAR_LENGTH:

                f.write(fd + '\n')

            else:
                sd = fd.split(f"{NEW_LINE_CHAR}{NEW_LINE_CHAR}")
                substring = ""
                for split in sd:
                    substring += split + f"{NEW_LINE_CHAR}{NEW_LINE_CHAR}"
                    if MIN_CHAR_LENGTH <= len(substring) <= MAX_CHAR_LENGTH:
                        f.write(substring + '\n')
                        substring = ""
        
        except Exception as e:
            print(str(e))


print("Dataset created!")