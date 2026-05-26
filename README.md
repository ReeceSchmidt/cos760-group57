# COS760 Group 57 — Cross-Lingual Detection of Machine-Generated Text in isiZulu

Binary classification of human-written vs machine-generated text in isiZulu and English using fine-tuned AfroXLMR, with LIME explainability analysis for cross-lingual feature comparison.

## Research Questions

1. How accurately can fine-tuned AfroXLMR detect machine-generated isiZulu text?
2. Does an English-trained classifier transfer to isiZulu, and what does LIME reveal about cross-lingual detection features?

## Project Structure

```
├── README.md
├── requirements.txt
├── data/
│   ├── raw/                    # Original source texts
│   │   ├── zul.csv             # Raw isiZulu (Vukuzenzele/Wikipedia)
│   │   ├── eng.csv             # Raw English
│   │   └── zul_cues.json       # 185 topic cues for generation
│   ├── processed/              # Cleaned and generated text
│   │   ├── human_zul_cleaned.csv
│   │   ├── human_eng_cleaned.csv
│   │   └── machine_generated_gemini.csv
│   └── splits/                 # Train/Val/Test (70/15/15)
│       ├── combined_train.csv / combined_val.csv / combined_test.csv
│       ├── eng_train.csv / eng_val.csv / eng_test.csv
│       └── zul_train.csv / zul_val.csv / zul_test.csv
├── scripts/                    # Data pipeline scripts
│   ├── clean_human_text.py     # Chunks raw text into 4-sentence segments
│   ├── generate_machine_text.py
│   └── generate_machine_text_resume.py
├── notebooks/                  # Google Colab notebooks
│   ├── AfroXLMR_Colab.ipynb    # Primary model (Davlan/afro-xlmr-base)
│   ├── XLMR_Colab.ipynb        # Baseline model (xlm-roberta-base)
│   └── LIME_Analysis.ipynb     # Explainability analysis
├── results/                    # Experiment outputs
│   └── lime/                   # LIME visualisations
├── report/                     # Final report (ACL format)
└── presentation/               # Slide deck
```

## Setup & Reproduction

### Requirements

- Python 3.10+
- Google Colab with T4 GPU (for training notebooks)
- See `requirements.txt` for all dependencies

### Step 1: Data Pipeline (already complete)

```bash
pip install -r requirements.txt
python scripts/clean_human_text.py
python scripts/generate_machine_text_resume.py
```

### Step 2: Model Training (Google Colab)

1. Open `notebooks/AfroXLMR_Colab.ipynb` in Google Colab
2. Enable T4 GPU: Runtime → Change runtime type → T4 GPU
3. Upload the 9 CSV files from `data/splits/`
4. Set `EXPERIMENT` to `'zul'`, `'eng'`, `'combined'`, or `'cross'`
5. Run cells top to bottom (~20 min per experiment)
6. Repeat with `notebooks/XLMR_Colab.ipynb` in a separate session

### Step 3: LIME Explainability

1. Open `notebooks/LIME_Analysis.ipynb` in Google Colab
2. Upload test CSVs and the saved model checkpoints
3. Run all cells to generate feature importance visualisations

## Models

| Model | HuggingFace ID | Purpose |
|-------|----------------|---------|
| AfroXLMR-base | `Davlan/afro-xlmr-base` | Primary — African language optimised |
| XLM-RoBERTa-base | `xlm-roberta-base` | Baseline comparison |

## Experiments

| Config | Train Data | Test Data | Purpose |
|--------|-----------|-----------|---------|
| isiZulu-only | zul_train | zul_test | RQ1 — monolingual detection |
| English-only | eng_train | eng_test | Monolingual baseline |
| Combined | combined_train | combined_test | Multilingual detection |
| Cross-lingual | eng_train | zul_test | RQ2 — transfer learning |

## Data Details

- **Human text:** isiZulu from Vukuzenzele/Wikipedia, English from news/Wikipedia
- **Machine text:** Generated with Gemma 4 (gemma-4-26b-a4b-it) via Google AI API
- **Generation:** 4 prompt templates × 185 cues × 2 languages
- **Chunking:** 4-sentence segments, minimum 30 words
- **Labels:** 0 = human, 1 = machine
- **Split:** 70% train / 15% validation / 15% test

## Metrics

Accuracy, Precision, Recall, F1 (macro), AUC-ROC

## Group Members

- [Add names and student numbers here]

## References

- Davlan et al. (2022). AfroXLMR — Scaling Multilingual Language Models for African Languages.
- Conneau et al. (2020). Unsupervised Cross-lingual Representation Learning at Scale (XLM-R).
- Ribeiro et al. (2016). LIME — Local Interpretable Model-agnostic Explanations.
