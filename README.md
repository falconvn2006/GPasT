[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/buckdan/GPasT/blob/main/GPasT.ipynb)
# GPasT
GPT for Pascal code generation :)

## Required dependencies
If you want to run the project locally. Here are the required dependencies that you have to download

```
// From HuggingFace
tokenizers
transformers 
datasets

// Raw data collection
pygithub
```

## Running the model
You can run it on [Google Colab](https://colab.research.google.com/github/buckdan/GPasT/blob/main/GPasT.ipynb), [HuggingFace](https://huggingface.co/Falcon2006VN/GPasT-small-model) or locally if you preferred.<br>

**For locally you have to run the script in this order** <br>
(if you don't want to create a new dataset, or train a new tokenizer then you can skip 1,2,3,4.<br>
After that you must go to the HuggingFace website and find my dataset [Falcon2006VN/pascal-code-generation-2mb]<br>
then you can retrain the model the way you like by adjusting the train.py then use the run.py to run the model)<br>
1. raw_data.py
2. clean.py
3. preprocess.py
4. tokenizer.py
5. train.py
6. run.py
