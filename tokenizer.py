from tokenizers import ByteLevelBPETokenizer
from transformers import GPT2Config, GPT2LMHeadModel, GPT2Tokenizer

data_paths = ["pascal_dataset_text_code.txt"]

tokenizer = ByteLevelBPETokenizer()

tokenizer.train(files=data_paths, vocab_size=52_000, min_frequency=2, special_tokens=[
    "<S>",
    "<pad>",
    "</s>",
    "<unk>",
    "<mask>",
])

tokenizer.save_model("tokenizer")


tokenizer = GPT2Tokenizer.from_pretrained("tokenizer")

tokenizer.add_special_tokens({
    "eos_token" : "</s>",
    "bos_token" : "<s>",
    "unk_token" : "<unk>",
    "pad_token" : "<pad>",
    "mask_token" : "<mask>"
})

# Testing the Tokenizer
#
inp = "writeln('Hello World'!);"
t = tokenizer.encode(inp)
print(t)
print(tokenizer.decode(t))
#