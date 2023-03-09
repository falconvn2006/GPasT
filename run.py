from tokenizers import ByteLevelBPETokenizer
from transformers import GPT2Config, GPT2LMHeadModel, GPT2Tokenizer, DataCollatorForLanguageModeling, \
                            Trainer, TrainingArguments
from datasets import load_dataset

data_paths = ["pascal_dataset_text_code.txt"] # Download the dataset from HuggingFace ("Falcon2006VN/pascal-code-generation-2mb")

tokenizer = GPT2Tokenizer.from_pretrained("tokenizer")

tokenizer.add_special_tokens({
    "eos_token" : "</s>",
    "bos_token" : "<s>",
    "unk_token" : "<unk>",
    "pad_token" : "<pad>",
    "mask_token" : "<mask>"
})

config = GPT2Config(
    vocab_size= tokenizer.vocab_size,
    bos_token = tokenizer.bos_token_id,
    eos_token = tokenizer.eos_token_id,
)

# Remove the .to("cuda")
# If you want to run from CPU

model = GPT2LMHeadModel.from_pretrained("GPasT").to("cuda")

# Type exit or quit when you done testing the model

while True:
  inp = input(">>> ")
  if inp == "quit" or inp == "exit":
    break
  print("Generating code...")
  input_ids = tokenizer.encode(inp, return_tensors="pt").to("cuda")
  beam_output = model.generate(input_ids,
                               max_length = 512,
                               num_beams = 10,
                               temperature = 0.7,
                               no_repeat_ngram_size = 5,
                               num_return_sequences = 1)
  

  for beam in beam_output:
    output = tokenizer.decode(beam)
    fout = output.replace("<N>", "\n")
    print(str(fout))
