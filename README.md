<p align="center">
    🤗 <a href="https://huggingface.co/datasets/Infinigence/LVEval" target="_blank">HF Repo</a> • 📃 <a href="https://arxiv.org/" target="_blank">Paper</a>
</p>

阅读[中文版本](README_ZH.md)。

# _LV_-Eval: A Balanced Long-Context Benchmark with 5 Length Levels Up to 256K

**_LV_-Eval** is a challenging long-context benchmark with five length levels (16k, 32k, 64k, 128k, and 256k) reaching up to 256k words. The average number of words is 102,380, and the Min/Max number of words is 11,896/387,406. **_LV_-Eval** features two main tasks, single-hop QA and multi-hop QA, comprising 11 bilingual datasets. The design of **_LV_-Eval** has incorporated three key techniques, namely confusing facts insertion (CFI), keyword and phrase replacement (KPR), and keyword-recall-based metrics (AK, short for metics with Answer Keywords and word blacklist) design, which jointly provide a challenging, mitigated-knowledge-leakege, and more accurate evaluation of the long-context capability of LLMs. We anticipate that **_LV_-Eval** will serve as a valuable resource for supporting future research on long-context LLMs.

## Key Characteristics

* **Sufficiently long context length to evaluate state-of-the-art models**: **_LV_-Eval** comprises 5 length levels with word counts of 16k, 32k, 64k, 128k, and 256k. Test instances across these levels share the same set of question-answer (QA) pairs, and only differ in the context content and length. Testing on the same QA pairs with different context lengths facilitates a controllable evaluation of models' long-context ability.
* **Incorporation of distraction and confusion to increase difficulty**: When constructing the context for each test instance, we mix up distracting documents and supporting documents. This approach evaluates the model's ability in pinpointing key information in a large bunch of distracting texts. In addition, we insert confusing facts generated by GPT-4 and revised by human annotators into the context. This assesses the model's capability to accurately reason in the presence of interference.
* **Keyword and phrase replacement to mitigate knowledge leakage**: To mitigate the biased evaluation of long-context ability caused by knowledge leakage, we apply keyword and phrase replacement in the context and QA pairs. The replacement rules are annotated by human annotators. In this way, **_LV_-Eval** requires LLMs to rely on their understanding of the long context to answer questions rather than relying on memorization or common-sense knowledge.
* **Keyword-recall-based metric for more objective scoring**: Existing $N$-gram metrics such as the F1 score are sensitive to the format variations and non-informative words in the answer, which results in inaccurate scores. To address this, we manually annotate answer keywords and a blacklist of unrelated words. The answer keywords are the critical words or sentences extracted from original ground-truth (GT) answers, while the word blacklist contains common and non-informative words such as 'the', 'a', 'of', and so on. The metric calculation follows a two-stage procedure: the first stage calculates the recall of answer keywords; if the recall exceeds a certain threshold, the second stage will remove all the blacklisted words and then calculate the F1 score between the prediction and the GT answer. This metric design can get scores with higher objectivity.

## Overview of **_LV_-Eval** 
In the following tables, CFI is short for **C**onfusiong **F**acts **I**nsertion, KPR is short for **K**eyword and **P**hrase **R**eplacement, and AK is short for **A**nswer **K**eywords used in keyword-recall-based metrics.

#### Single-hop QA
In a single-hop QA task, only a single evidence in the context is needed to derive the answer.

|        Dataset        | CFI | \#KPR | AK | Language | \#QA pairs | \#Contexts |
|:---------------------:|:---:|-------|:--:|:--------:|:----------:|:----------:|
|    loogle-SD-mixup    |     |       |  ✔ |    en    |     160    |     800    |
|       cmrc-mixup      |     |  786  |    |    zh    |     200    |    1,000   |
| multifieldqa-en-mixup |  ✔  |  476  |  ✔ |    en    |     101    |     505    |
| multifieldqa-zh-mixup |  ✔  |  424  |  ✔ |    zh    |     133    |     665    |
|     factrecall-en     |  ✔  |   3   |  ✔ |    en    |      1     |   200 * 5  |
|     factrecall-zh     |  ✔  |   3   |  ✔ |    zh    |      1     |   200 * 5  |

**factrecall-en** and **factrecall-zh** are designed for presure test of "needle in haystack", so the qa pair is kept the same across all data instances.

#### Multi-hop QA
In multi-hop QA tasks, the reasoning to derive the answer needs to gather multiple pieces of information from various locations in the context.

|        Dataset        | CFI | \#KPR | AK | Language | \#QA pairs | \#Contexts |
|:---------------------:|:---:|-------|:--:|:--------:|:----------:|:----------:|
|     dureader-mixup    |     |       |    |    zh    |     176    |     880    |
|    loogle-CR-mixup    |     |       |  ✔ |    en    |     99     |     495    |
|    loogle-MR-mixup    |     |       |  ✔ |    en    |     139    |     695    |
|   hotpotwikiqa-mixup  |  ✔  |  232  |  ✔ |    en    |     124    |     620    |
|       lic-mixup       |  ✔  |       |  ✔ |    zh    |     197    |     985    |

## Table of Contents
- [Leaderboard](#leaderboard)
- [Evaluate Your LLMs on **_LV_-Eval**](#evaluate-your-llms-on-lv-eval)
- [Detail Result on Each Dataset](#detail-result-on-each-dataset)
- [License](#license)
- [Citation](#citation)

<a name="leaderboard"></a>
## Leaderboard
Here is the average scores (%) over all tasks on 5 length levels. We evaluate 2 commercial LLMs an 8 open-source LLMs.

#### Evaluated LLMs
|       Model Name       |     SFT    | Context Length |        HuggingFace / API Endpoint        |
|:----------------------:|:----------:|:--------------:|:----------------------------------------:|
|    Llama2-7B-Chat-hf   | ✔ |      $4k$      |       meta-llama/Llama-2-7b-chat-hf      |
|     Qwen-7B-8k-Chat    | ✔ |      $8k$      |             Qwen/Qwen-7B-Chat            |
|   Vicuna-7B-16k-v1.5   | ✔ |      $16k$     |         lmsys/vicuna-7b-v1.5-16k         |
|     ChatGLM3-6B-32k    | ✔ |      $32k$     |           THUDM/chatglm3-6b-32k          |
| Llama2-7B-32k-Instruct | ✔ |      $32k$     | togethercomputer/Llama-2-7B-32K-Instruct |
|   BlueLM-7B-32k-Chat   | ✔ |      $32k$     |        vivo-ai/BlueLM-7B-Chat-32K        |
|  LongChat-7B-32k-v1.5  | ✔ |      $32k$     |        lmsys/longchat-7b-v1.5-32k        |
|       Yi-6B-200k       |            |     $200k$     |             01-ai/Yi-6B-200K             |
|        GPT-4-8k        | ✔ |      $8k$      |                gpt-4-0613                |
|       GPT-3.5-16k      | ✔ |      $16k$     |            gpt-3.5-turbo-1106            |            

#### Overall Result
![](info/merge_res.png)

|       Model Name       |  $16k$ |  $32k$ |  $64k$ | $128k$ | $256k$ |
|:----------------------:|:------:|:------:|:------:|:------:|:------:|
|     ChatGLM3-6B-32k    | 30.70  | 26.62  | 17.62  | 11.56  |  7.17  |
|   BlueLM-7B-32k-Chat   | 24.09  | 16.80  | 9.22   | 6.51   |  4.77  |
|       Yi-6B-200k       | 13.73  | 11.95  | 9.82   | 8.24   |  5.28  |
|  LongChat-7B-32k-v1.5  | 13.54  | 10.70  | 6.80   | 5.35   |  4.22  |
| Llama2-7B-32k-Instruct | 13.66  | 10.07  | 6.03   | 4.43   |  2.87  |
|     Qwen-7B-8k-Chat    | 7.90   | 4.86   | 3.88   | 3.00   |  2.71  |
|   Vicuna-7B-16k-v1.5   | 5.77   | 3.90   | 2.62   | 2.07   |  1.92  |
|    Llama2-7B-Chat-hf   | 4.18   | 2.19   | 1.81   | 1.45   |  1.10  |
|       GPT-3.5-16k      | 14.09  | 8.19   | 4.94   | 3.21   |  2.23  |
|        GPT-4-8k        | 18.27  | 10.60  | 6.84   | 4.08   |  2.54  |

<a name="evaluate-your-llms-on-lv-eval"></a>
## Evaluate Your LLMs on **_LV_-Eval**


#### Load Data
```python
from datasets import load_dataset

DATASET_NAMES = [
    "hotpotwikiqa_mixup", "loogle_SD_mixup", "loogle_CR_mixup", "loogle_MIR_mixup", \
    "multifieldqa_en_mixup", "multifieldqa_zh_mixup", "factrecall_en", "factrecall_zh", \
    "cmrc_mixup", "lic_mixup", "dureader_mixup"
]

DATASET_LENGTH_LEVEL = [
    '16k', '32k', '64k', '128k', '256k'
]

def get_dataset_names(dataset_names, length_levels):
    datasets = []
    for name in dataset_names:
        for length in length_levels:
            datasets.append(f"{name}_{length}")
    return datasets

for dataset in get_dataset_names(DATASET_NAMES, DATASET_LENGTH_LEVEL):
    data = load_dataset("Infinigence/LVEval", dataset, split='test', token=True)
```

Alternatively, you can download datas to your local folder from the following link: `https://huggingface.co/datasets/Infinigence/LVEval/resolve/main/{task_name}.zip`

remember to replace {task_name} with the name of the subset you want.

For example, if you want to download the data for hotpotwikiqa_mixup, you can visit this link: https://huggingface.co/datasets/Infinigence/LVEval/resolve/main/hotpotwikiqa_mixup.zip

#### Data Format
All data in **_LV_-Eval** follows the following format.

```json
{
    "input": "The input/command for the task, usually short, such as questions in QA, queries in Few-shot tasks, etc",
    "context": "The documents input into the long-text task.",
    "answers": "A List of all true answers",
    "length": "Total length of the first three items (counted in characters for Chinese and words for English)",
    "dataset": "The name of the dataset to which this piece of data belongs",
    "language": "The language of this piece of data",
    "answer_keywords": "The key words or sentences manually filtered from the answers",
    "confusing_facts": "This key represents confusing facts inserted to context to make the evaluation more challenging.",
}
```

#### Evaluation
Install the requirements with pip: `pip install -r requirements.txt`.

Generally, we run evaluation in data parrallel mode. We need to select model_path, model_name(Modify this to make it compatible with the names defined in the build_chat function in [utils.py](utils.py) for customized prompt format needs) and model_max_length(-500 to reserve output window) sequeentially in the shell scripts. For example:
```bash
bash batch_eval_multiple.sh /home/user/workspace/public_models/chatglm3-6b-32k chatglm3 31500
```
For models with extra long context windows or exceeding model size, we suggest to run evaluation in HF auto model parrallel mode. For example:
```bash
bash batch_eval_single.sh /home/user/workspace/public_models/Yi-6B-200K yi-200k 199500
```
We can also run evaluation step by step. Firstly, run [prediction.py](predictioin.py) to get inference results. We need to select model via `--model-path`, define model name via `--model-name`, input model max length via `--model-max-len`, and define output directory via `--output-dir`. For example:
```bash
python prediction.py --model-path /home/user/workspace/public_models/chatglm3-6b-32k --model-name chatglm3 --model-max-len 31500 --output-dir ./outputs/
```
The prediction results will be saved in `[output dir]/[model name]`.
Then, we can run [evaluation.py](evaluation.py) on prediction results we obtained before, to get the evaluation results of _LV_-Eval. The prediction results directory need to be defined via `--input-dir`. For example:
```bash
python evaluation.py --input-dir ./outputs/chatglm3/
```
After that, we will see evaluation results printed in shell, and get `results.json`, `results.csv` file in output directory.

The cusetome needs can be defined in [config.py](config.py) (for selecting the datasets and length levels we want to evaluate) and [utils.py](utils.py) (for customize the prompt format of our models). 

Additionally, we evaluate some commercial models with API through the following scipts. For example, evaluate OpenAI's GPT series, we need to select model_name and model_max_length.
Note the OPENAI_API_KEY need to be set before evaluation.
```bash
bash batch_eval_gpt_single.sh gpt-4-1106-preview 127500
```

<a name="detail-result-on-each-dataset"></a>
## Detail Result on Each Dataset
Average scores over all length levels on each dataset.

#### Single-hop QA
![](info/bar_perf_sqa.png)

|       Model Name       | loogle-SD-mixup | cmrc-mixup | multifieldqa-en-mixup | multifieldqa-zh-mixup | factrecall-en | factrecall-zh |
|:----------------------:|:---------------:|:----------:|:---------------------:|:---------------------:|:-------------:|:-------------:|
|     ChatGLM3-6B-32k    |      22.29      |    28.16   |         12.93        |        18.99        |      52.60     |      6.10      |
|   BlueLM-7B-32k-Chat   |      13.02      |    17.53   |         7.32        |         11.49       |     24.03    |      18.80     |
|       Yi-6B-200k       |      29.17      |    1.27   |         7.75        |        1.84        |     22.28    |     13.95     |
|  LongChat-7B-32k-v1.5  |      14.56      |    9.65    |         6.95        |         5.86       |     9.14     |      4.28     |
| Llama2-7B-32k-Instruct |      7.63       |    6.12   |         4.63        |         2.56       |     38.09     |      0.92     |
|     Qwen-7B-8k-Chat    |      4.78       |    5.81   |         4.52        |         4.57       |      0.80      |      5.45     |
|   Vicuna-7B-16k-v1.5   |      4.68       |    6.04   |         3.44        |         2.89       |      0.09     |       0       |
|    Llama2-7B-Chat-hf   |      3.04       |    1.97   |         3.99        |         1.48       |     0.45     |       0       |
|       GPT-3.5-16k      |      13.99     |    5.16   |         9.78        |         8.51       |     2.87     |      5.28     |
|        GPT-4-8k        |      11.13     |    5.96    |         10.16        |        7.29        |     9.25    |     11.39    |

#### Multi-hop QA
![](info/bar_perf_mqa.png)

|       Model Name       | dureader-mixup | loogle-CR-mixup | loogle-MR-mixup | hotpotwikiqa-mixup | lic-mixup |  
|:----------------------:|:--------------:|:---------------:|:---------------:|:------------------:|:---------:|
|     ChatGLM3-6B-32k    |     19.57     |      10.17     |      9.10      |       11.15       |   15.02  |
|   BlueLM-7B-32k-Chat   |     14.61     |      5.04      |      2.87      |       11.22       |   9.11   |
|       Yi-6B-200k       |      2.83      |      5.82      |      4.41      |       12.42       |   6.12   |
|  LongChat-7B-32k-v1.5  |     10.34     |       8.59      |      6.03      |        6.98       |   6.92   |
| Llama2-7B-32k-Instruct |      9.57     |      2.51      |      1.92      |        2.31       |   5.27   |
|     Qwen-7B-8k-Chat    |     10.42     |      3.14      |      2.70      |        2.23       |   4.77   |
|   Vicuna-7B-16k-v1.5   |      7.18     |      3.26      |      2.31      |        1.95        |   4.00   |
|    Llama2-7B-Chat-hf   |      5.49      |      2.62      |      1.80      |        1.74        |    1.02   |
|       GPT-3.5-16k      |      4.87     |      6.09      |      5.87      |        5.88       |   3.53   |
|        GPT-4-8k        |     12.07     |       7.26      |      5.91      |        7.46       |   5.28   |

Scores of each length levels on each dataset.

#### loogle-SD-mixup
|       Model Name       | $16k$ | $32k$ | $64k$ | $128k$ | $256k$ |
|:----------------------:|-------|-------|-------|--------|--------|
|     ChatGLM3-6B-32k    | 41.82 | 30.31 | 19.07 | 11.34  | 8.92   |
|   BlueLM-7B-32k-Chat   | 34.34 | 15.10  | 4.95  | 5.32   | 5.41   |
|       Yi-6B-200k       | 39.56 | 36.48 | 31.71 | 25.71  | 12.37  |
|  LongChat-7B-32k-v1.5  | 27.42 | 18.21 | 12.09 | 9.11   | 5.97   |
| Llama2-7B-32k-Instruct | 13.94 | 10.58 | 5.53  | 4.80    | 3.30    |
|     Qwen-7B-8k-Chat    | 10.54 | 4.70   | 2.40   | 3.25   | 3.02   |
|   Vicuna-7B-16k-v1.5   | 8.79  | 4.90   | 3.07  | 4.24   | 2.39   |
|    Llama2-7B-Chat-hf   | 6.75  | 2.61  | 2.58  | 2.04   | 1.24   |
|       GPT-3.5-16k      | 31.67 | 18.56 | 10.41 | 5.74   | 3.56   |
|        GPT-4-8k        | 27.01 | 14.01 | 8.00     | 5.14   | 1.48   |

#### cmrc-mixup
|       Model Name       | $16k$ | $32k$ | $64k$ | $128k$ | $256k$ |
|:----------------------:|-------|-------|-------|--------|--------|
|     ChatGLM3-6B-32k    | 51.21 | 46.34 | 20.71 | 14.16  | 8.38   |
|   BlueLM-7B-32k-Chat   | 45.89 | 19.53 | 10.66 | 7.06   | 4.51   |
|       Yi-6B-200k       | 1.05  | 0.35  | 0.84  | 1.58   | 2.54   |
|  LongChat-7B-32k-v1.5  | 20.99 | 10.77 | 8.97  | 3.77   | 3.75   |
| Llama2-7B-32k-Instruct | 13.86 | 7.31  | 4.10   | 2.95   | 2.40    |
|     Qwen-7B-8k-Chat    | 11.13 | 5.32  | 4.68  | 3.81   | 4.09   |
|   Vicuna-7B-16k-v1.5   | 11.75 | 6.55  | 5.04  | 2.75   | 4.13   |
|    Llama2-7B-Chat-hf   | 3.85  | 1.08  | 1.72  | 1.64   | 1.54   |
|       GPT-3.5-16k      | 12.19 | 6.00     | 3.57  | 2.73   | 1.32   |
|        GPT-4-8k        | 14.67 | 3.33  | 5.31  | 3.81   | 2.68   |

#### multifieldqa-en-mixup				
|       Model Name       | $16k$ | $32k$ | $64k$ | $128k$ | $256k$ |
|:----------------------:|-------|-------|-------|--------|--------|
|     ChatGLM3-6B-32k    | 25.40  | 12.78 | 12.32 |  9.89  | 4.24   |
|   BlueLM-7B-32k-Chat   | 11.82 | 6.34  | 8.38  |  5.29  | 4.78   |
|       Yi-6B-200k       | 10.01 | 9.24  | 8.83  |  5.98  | 4.69   |
|  LongChat-7B-32k-v1.5  | 12.02 | 7.58  | 7.84  |  3.11  | 4.22   |
| Llama2-7B-32k-Instruct | 8.03  | 4.96  | 4.12  |  3.90   | 2.13   |
|     Qwen-7B-8k-Chat    | 7.66  | 3.61  | 5.23  |  3.64  | 2.44   |
|   Vicuna-7B-16k-v1.5   | 6.29  | 4.32  | 2.79  |  2.51  | 1.28   |
|    Llama2-7B-Chat-hf   | 8.81  | 5.55  | 1.58  |  2.54  | 1.49   |
|       GPT-3.5-16k      | 18.78 | 11.59 | 7.38  |  7.95  | 3.21   |
|        GPT-4-8k        | 19.00    | 12.69 | 8.30   |  7.25  | 3.54   |

#### multifieldqa-zh-mixup				
|       Model Name       | $16k$ | $32k$ | $64k$ | $128k$ | $256k$ |
|:----------------------:|-------|-------|-------|--------|--------|
|     ChatGLM3-6B-32k    | 32.38 | 24.48 | 20.97 | 10.00   | 7.05   |
|   BlueLM-7B-32k-Chat   | 22.05 | 17.64 | 7.36  | 5.90    | 4.48   |
|       Yi-6B-200k       | 2.85  | 0.75  | 1.89  | 2.11   | 1.58   |
|  LongChat-7B-32k-v1.5  | 9.81  | 8.82  | 3.23  | 3.54   | 3.92   |
| Llama2-7B-32k-Instruct | 4.55  | 3.93  | 1.45  | 1.74   | 1.15   |
|     Qwen-7B-8k-Chat    | 8.82  | 5.68  | 3.01  | 2.84   | 2.52   |
|   Vicuna-7B-16k-v1.5   | 5.82  | 4.45  | 2.03  | 0.88   | 1.26   |
|    Llama2-7B-Chat-hf   | 4.72  | 1.21  | 0.68  | 0.24   | 0.56   |
|       GPT-3.5-16k      | 18.94 | 12.21 | 6.29  | 2.94   | 2.15   |
|        GPT-4-8k        | 17.61 | 11.18 | 4.99  | 1.76   | 0.92   |

#### factrecall-en
|       Model Name       | $16k$ | $32k$ | $64k$ | $128k$ | $256k$ |
|:----------------------:|-------|-------|-------|--------|--------|
|     ChatGLM3-6B-32k    | 91.50  | 89.00    | 46.00    | 24.00     | 12.5   |
|   BlueLM-7B-32k-Chat   | 58.50  | 32.17 | 15.50  | 9.00      | 5.00      |
|       Yi-6B-200k       | 24.88 | 23.09 | 24.96 | 22.04  | 16.44  |
|  LongChat-7B-32k-v1.5  | 9.22  | 14.33 | 8.31  | 7.86   | 6.00      |
| Llama2-7B-32k-Instruct | 75.20  | 56.00    | 33.00    | 17.85  | 8.40    |
|     Qwen-7B-8k-Chat    | 1.77  | 1.12  | 0.71  | 0.18   | 0.22   |
|   Vicuna-7B-16k-v1.5   | 0     | 0     | 0     | 0.25   | 0.20    |
|    Llama2-7B-Chat-hf   | 1.08  | 0.46  | 0.31  | 0.23   | 0.15   |
|       GPT-3.5-16k      | 8.25  | 3.27  | 1.80  | 0.60   | 0.45   |
|        GPT-4-8k        | 23.40 | 11.84  | 5.21  | 4.03   | 1.79   |

#### factrecall-zh
|       Model Name       | $16k$ | $32k$ | $64k$ | $128k$ | $256k$ |
|:----------------------:|-------|-------|-------|--------|--------|
|     ChatGLM3-6B-32k    | 0     | 2.00     | 12.50  | 9.00      | 7.00      |
|   BlueLM-7B-32k-Chat   | 19.00    | 37.00    | 20.00    | 12.50   | 5.50    |
|       Yi-6B-200k       | 25.73 | 16.86 | 12.41 | 10.13  | 4.62   |
|  LongChat-7B-32k-v1.5  | 7.20   | 5.00     | 3.50   | 3.70    | 2.00      |
| Llama2-7B-32k-Instruct | 2.55  | 0.74  | 0.53  | 0.49   | 0.29   |
|     Qwen-7B-8k-Chat    | 15.75 | 6.00     | 3.50   | 1.50    | 0.50    |
|   Vicuna-7B-16k-v1.5   | 0     | 0     | 0     | 0      | 0      |
|    Llama2-7B-Chat-hf   | 0     | 0     | 0     | 0      | 0      |
|       GPT-3.5-16k      | 14.51 | 6.70   | 2.49  | 1.72   | 0.98   |
|        GPT-4-8k        | 28.03 | 15.24 | 8.08  | 3.58   | 2.00      |

#### dureader-mixup
|       Model Name       | $16k$ | $32k$ | $64k$ | $128k$ | $256k$ |
|:----------------------:|-------|-------|-------|--------|--------|
|     ChatGLM3-6B-32k    | 23.99 | 25.21 | 22.01 | 17.94  | 8.72   |
|   BlueLM-7B-32k-Chat   | 19.40  | 19.74 | 14.44 | 10.95  | 8.51   |
|       Yi-6B-200k       | 2.87  | 2.98  | 2.88  | 2.36   | 3.06   |
|  LongChat-7B-32k-v1.5  | 13.44 | 11.57 | 9.23  | 9.51   | 7.96   |
| Llama2-7B-32k-Instruct | 11.82 | 10.65 | 8.58  | 9.34   | 7.48   |
|     Qwen-7B-8k-Chat    | 12.00    | 12.80  | 10.48 | 8.15   | 8.65   |
|   Vicuna-7B-16k-v1.5   | 9.67  | 7.65  | 6.62  | 6.25   | 5.70    |
|    Llama2-7B-Chat-hf   | 7.21  | 5.42  | 5.59  | 4.78   | 4.45   |
|       GPT-3.5-16k      | 8.01  | 5.26  | 4.26  | 3.30    | 3.50    |
|        GPT-4-8k        | 19.14 | 13.64 | 12.66 | 8.19   | 6.71   |

#### loogle-CR-mixup				
|       Model Name       | $16k$ | $32k$ | $64k$ | $128k$ | $256k$ |
|:----------------------:|-------|-------|-------|--------|--------|
|     ChatGLM3-6B-32k    | 14.41 | 14.10  | 9.92  | 6.95   | 5.46   |
|   BlueLM-7B-32k-Chat   | 9.01  | 7.36  | 3.81  | 2.40    | 2.60    |
|       Yi-6B-200k       | 8.25  | 8.83  | 4.73  | 4.05   | 3.23   |
|  LongChat-7B-32k-v1.5  | 11.25 | 11.17 | 9.31  | 6.19   | 5.03   |
| Llama2-7B-32k-Instruct | 3.11  | 2.82  | 2.01  | 2.46   | 2.16   |
|     Qwen-7B-8k-Chat    | 5.48  | 3.30   | 3.82  | 1.14   | 1.94   |
|   Vicuna-7B-16k-v1.5   | 5.00     | 4.25  | 3.76  | 1.99   | 1.28   |
|    Llama2-7B-Chat-hf   | 3.69  | 3.29  | 3.13  | 2.19   | 0.81   |
|       GPT-3.5-16k      | 10.04 | 8.39  | 5.58  | 3.08   | 3.37   |
|        GPT-4-8k        | 12.68 | 10.40  | 6.48  | 2.83   | 3.91   |

#### loogle-MR-mixup
|       Model Name       | $16k$ | $32k$ | $64k$ | $128k$ | $256k$ |
|:----------------------:|-------|-------|-------|--------|--------|
|     ChatGLM3-6B-32k    | 15.83 | 11.62 | 7.00     | 7.24   | 3.82   |
|   BlueLM-7B-32k-Chat   | 4.90   | 3.14  | 1.68  | 2.46   | 2.19   |
|       Yi-6B-200k       | 6.94  | 7.67  | 2.69  | 3.44   | 1.32   |
|  LongChat-7B-32k-v1.5  | 10.53 | 9.51  | 3.04  | 4.05   | 3.01   |
| Llama2-7B-32k-Instruct | 3.12  | 2.61  | 1.44  | 1.47   | 0.95   |
|     Qwen-7B-8k-Chat    | 4.93  | 2.95  | 2.37  | 1.80    | 1.46   |
|   Vicuna-7B-16k-v1.5   | 5.17  | 3.83  | 0.96  | 0.55   | 1.06   |
|    Llama2-7B-Chat-hf   | 3.37  | 2.20   | 2.05  | 1.04   | 0.33   |
|       GPT-3.5-16k      | 12.95 | 7.03  | 6.23  | 2.13   | 1.00      |
|        GPT-4-8k        | 12.24 | 7.83  | 6.26  | 2.30    | 0.90    |

#### hotpotwikiqa-mixup
|       Model Name       | $16k$ | $32k$ | $64k$ | $128k$ | $256k$ |
|:----------------------:|-------|-------|-------|--------|--------|
|     ChatGLM3-6B-32k    | 16.98 | 14.76 | 9.02  | 8.31   | 6.68   |
|   BlueLM-7B-32k-Chat   | 19.31 | 14.07 | 9.63  | 7.71   | 5.40    |
|       Yi-6B-200k       | 23.55 | 18.94 | 9.94  | 7.66   | 2.01   |
|  LongChat-7B-32k-v1.5  | 11.57 | 10.71 | 4.77  | 5.49   | 2.37   |
| Llama2-7B-32k-Instruct | 3.54  | 2.31  | 2.20   | 1.86   | 1.62   |
|     Qwen-7B-8k-Chat    | 2.78  | 1.89  | 2.27  | 2.37   | 1.82   |
|   Vicuna-7B-16k-v1.5   | 2.63  | 2.19  | 2.05  | 1.04   | 1.85   |
|    Llama2-7B-Chat-hf   | 3.99  | 1.30   | 1.84  | 0.81   | 0.75   |
|       GPT-3.5-16k      | 11.96 | 6.66  | 3.27  | 4.23   | 3.30    |
|        GPT-4-8k        | 13.51 | 10.62 | 6.67  | 4.13   | 2.36   |

#### lic-mixup
|       Model Name       | $16k$ | $32k$ | $64k$ | $128k$ | $256k$ |
|:----------------------:|-------|-------|-------|--------|--------|
|     ChatGLM3-6B-32k    | 24.15 | 22.27 | 14.33 | 8.30    | 6.07   |
|   BlueLM-7B-32k-Chat   | 20.75 | 12.68 | 5.00     | 3.03   | 4.11   |
|       Yi-6B-200k       | 5.37  | 6.25  | 7.19  | 5.56   | 6.24   |
|  LongChat-7B-32k-v1.5  | 15.45 | 10.02 | 4.54  | 2.47   | 2.14   |
| Llama2-7B-32k-Instruct | 10.55 | 8.87  | 3.41  | 1.85   | 1.66   |
|     Qwen-7B-8k-Chat    | 6.05  | 6.07  | 4.21  | 4.34   | 3.19   |
|   Vicuna-7B-16k-v1.5   | 8.34  | 4.81  | 2.52  | 2.36   | 1.99   |
|    Llama2-7B-Chat-hf   | 2.48  | 0.99  | 0.48  | 0.42   | 0.73   |
|       GPT-3.5-16k      | 7.65  | 4.42  | 3.07  | 0.87   | 1.65   |
|        GPT-4-8k        | 13.69 | 5.86  | 3.23  | 1.90    | 1.70    |

<a name="license"></a>
## License
In **_LV_-Eval**, the cmrc-mixup and lic-mixup datasets follow `CC-BY-SA-4.0` license, and the other datasets follow `MIT` license.

<a name="citation"></a>
## Citation
```
@misc{yuan2024lveval,
      title={LV-Eval: A Balanced Long-Context Benchmark with 5 Length Levels Up to 256K}, 
      author={Tao Yuan and Xuefei Ning and Dong Zhou and Zhijie Yang and Shiyao Li and Minghui Zhuang and Zheyue Tan and Zhuyu Yao and Dahua Lin and Boxun Li and Guohao Dai and Shengen Yan and Yu Wang},
      year={2024},
      eprint={},
      archivePrefix={arXiv},
      primaryClass={cs.CL}
}
```