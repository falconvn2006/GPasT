import os
import time
# import tqdm

dataset_path = "dataset"

for dirpath, dirnames, filenames in os.walk(dataset_path):
    for f in filenames:
        full_path = os.path.join(dirpath, f)
        # print(full_path)

        if full_path.endswith(".pas"):
            print(f"Pascal file founded at : {full_path}")
        else:
            if dataset_path in full_path:
                print("#################################")
                print(f"Removing junk file {full_path}")
                os.remove(full_path)
            else:
                print("An error has occurred. Pausing for 60s")
                time.sleep(60)

print("Clean dataset completed!")