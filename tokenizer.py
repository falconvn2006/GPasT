from tokenizers import ByteLevelBPETokenizer
from transformers import GPT2Config, GPT2LMHeadModel, GPT2Tokenizer

TRAINED = False
data_paths = ["pascal_dataset_text_code.txt"]

if not TRAINED:
    tokenizer = ByteLevelBPETokenizer()

    tokenizer.train(files=data_paths, vocab_size=52_000, min_frequency=2, special_tokens=[
        "<S>",
        "<pad>",
        "</s>",
        "<unk>",
        "<mask>",
    ])

    tokenizer.save_model("tokenizer")

inp = "writeln('Hello World'!);"

tokenizer = GPT2Tokenizer.from_pretrained("tokenizer")

tokenizer.add_special_tokens({
    "eos_token" : "</s>",
    "bos_token" : "<s>",
    "" : ""
})