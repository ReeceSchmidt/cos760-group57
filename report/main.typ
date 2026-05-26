#import "@preview/tracl:0.8.1": *
#import "@preview/pergamon:0.7.1": *

#show: doc => acl(doc,
  anonymous: false,
  title: [Cross-Lingual Detection of Machine-Generated Text in isiZulu Using Transfer Learning and Explainability Analysis],
  authors: make-authors(
    (name: "Reece Schmidt", affiliation: [University of Pretoria\ #email("u19130539@tuks.co.za")]),
    (name: "Ayanda Juqu", affiliation: [University of Pretoria\ #email("u21589021@tuks.co.za")]),
    (name: "Conrad Nicolas du Toit", affiliation: [University of Pretoria\ #email("U26848912@tuks.co.za")]),
  ),
)

#abstract[
  The proliferation of large language models capable of generating fluent text in multiple languages raises concerns about the detection of machine-generated text (MGT), particularly in low-resource African languages. This paper investigates the detection of machine-generated isiZulu text using fine-tuned AfroXLMR, a multilingual transformer optimised for African languages. We construct a balanced dataset of human-written and machine-generated text in both isiZulu and English, generated using Gemma 4. We evaluate monolingual, multilingual, and cross-lingual detection configurations, achieving an F1 score of 0.975 on isiZulu monolingual detection and 0.737 on cross-lingual transfer (English→isiZulu). Using LIME explainability analysis, we compare which linguistic features drive detection in each setting. Our findings demonstrate that AfroXLMR provides highly effective MGT detection for isiZulu and that cross-lingual transfer from English is feasible but substantially degraded, highlighting the importance of language-specific training for morphologically rich languages.
]

// ============================================================
= Introduction

The rapid advancement of large language models (LLMs) has made it increasingly difficult to distinguish human-written text from machine-generated text (MGT). While detection methods have been extensively studied for high-resource languages such as English @jawahar2020 @mitchell2023, low-resource languages remain underexplored. This gap is particularly concerning for African languages, where MGT could be misused in educational assessment, journalism, and government communications without adequate detection tools.

isiZulu is the most widely spoken home language in South Africa, with over 12 million first-language speakers. As a Bantu language, it exhibits agglutinative morphology with complex noun class systems and verbal extensions that differ fundamentally from English. These linguistic properties present unique challenges for MGT detection: models trained on English text may not transfer effectively to isiZulu due to structural differences in how meaning is encoded.

We address two research questions:

+ How accurately can a fine-tuned AfroXLMR model detect machine-generated isiZulu text?
+ Does an English-trained classifier transfer to isiZulu, and what does LIME reveal about the features driving cross-lingual detection?

We fine-tune AfroXLMR @alabi2022, a multilingual transformer with additional African language pretraining, on monolingual, multilingual, and cross-lingual configurations. We compare against XLM-RoBERTa @conneau2020 as a baseline to isolate the benefit of African language specialisation. We apply LIME @ribeiro2016 to interpret model decisions and compare feature importance across detection settings.

Our contributions are: (1) the first evaluation of transformer-based MGT detection for isiZulu, (2) a cross-lingual transfer analysis showing the limitations of English-trained detectors on agglutinative languages, and (3) an explainability comparison revealing how monolingual and cross-lingual models differ in their detection strategies.

The remainder of this paper is organised as follows: Section 2 reviews related work, Section 3 describes our methodology, Section 4 presents experimental results, Section 5 discusses findings and limitations, and Section 6 concludes.

// ============================================================
= Related Work

== Machine-Generated Text Detection

Early approaches to MGT detection relied on statistical features such as perplexity, burstiness, and vocabulary richness @gehrmann2019. The GLTR tool visualised token-level generation probabilities to assist human detection. With the release of GPT-2, @solaiman2019 demonstrated that fine-tuned transformers could achieve near-perfect detection on English text, establishing supervised classification as the dominant paradigm.

More recently, @mitchell2023 introduced DetectGPT, a zero-shot method using perturbation-based log-probability curvature that requires no training data. However, zero-shot methods generally underperform supervised approaches when labelled data is available, and their applicability to low-resource languages with limited language model coverage remains unclear.

== Multilingual and Cross-Lingual Detection

Cross-lingual transfer for NLP tasks has been enabled by multilingual pretrained models such as mBERT and XLM-RoBERTa @conneau2020. These models learn shared representations across languages, enabling zero-shot transfer where a model trained on one language is applied to another. However, transfer effectiveness varies significantly depending on linguistic similarity and representation in pretraining data.

For MGT detection specifically, @wang2024 demonstrated in the M4 benchmark that English-trained detectors show substantially degraded performance on non-English text, with particularly large drops for languages with different scripts or morphological systems. This motivates language-specific approaches for underrepresented languages.

== African Language NLP

AfroXLMR @alabi2022 extends XLM-RoBERTa with multilingual adaptive fine-tuning on 17 African languages, including isiZulu. It achieves state-of-the-art results on named entity recognition, sentiment analysis, and text classification tasks for African languages, outperforming both language-specific models and general multilingual models. To our knowledge, no prior work has applied AfroXLMR or any transformer-based approach to MGT detection in isiZulu or other Bantu languages.

== Explainability in Text Classification

LIME (Local Interpretable Model-agnostic Explanations) @ribeiro2016 provides instance-level explanations by perturbing input features and fitting a local linear model to approximate the classifier's decision boundary. For text classification, LIME identifies which tokens most strongly influence predictions, enabling qualitative analysis of what linguistic features a model has learned to associate with each class. This is particularly valuable for understanding cross-lingual transfer, where the features driving detection may differ from those in the source language.

// ============================================================
= Methodology

== Dataset Construction

We construct a balanced binary classification dataset in isiZulu and English. Each sample is labelled as human-written (0) or machine-generated (1).

*Human text:* isiZulu text is sourced from Vukuzenzele, a South African government magazine published in all 11 official languages, and isiZulu Wikipedia articles. English text is sourced from news articles and English Wikipedia. Raw text is segmented into 4-sentence chunks with a minimum length of 30 words to ensure comparable length distributions between human and machine-generated samples.

*Machine text:* We generate text using Gemma 4 (gemma-4-26b-a4b-it) via the Google AI API. We design 185 topic cues covering diverse domains (politics, health, education, culture, science) and pair each with 4 prompt templates that vary in style (formal, conversational, narrative, informative). This produces 740 generation requests per language, yielding balanced machine-generated samples in both isiZulu and English.

*Dataset splits:* We create stratified 70/15/15 train/validation/test splits for three configurations: isiZulu-only (946/203/203 samples), English-only (977/209/210 samples), and combined (1923/412/413 samples). The cross-lingual configuration uses English training data with isiZulu test data.

== Models

We fine-tune two pretrained models for binary sequence classification:

- *AfroXLMR-base* (`Davlan/afro-xlmr-base`): 278M parameters. XLM-RoBERTa with additional multilingual adaptive fine-tuning on 17 African languages including isiZulu. This is our primary model.
- *XLM-RoBERTa-base* (`xlm-roberta-base`): 278M parameters. The general multilingual model pretrained on 100 languages without African language specialisation. This serves as our baseline.

Both models use the same architecture (12 layers, 768 hidden dimensions, 12 attention heads) with a linear classification head.

== Training Configuration

Both models are fine-tuned with identical hyperparameters to ensure fair comparison: learning rate $2 times 10^(-5)$ with linear warmup over 10% of training steps, batch size 16, maximum sequence length 256 tokens, weight decay 0.01, and training for up to 5 epochs. We apply early stopping with patience 2 based on validation macro F1, restoring the best checkpoint at the end of training. All experiments use seed 42 for reproducibility.

== Experimental Configurations

We evaluate four configurations per model, as shown in @tab:configs.

#figure(
  table(
    columns: 4,
    [*Config*], [*Train Data*], [*Test Data*], [*Purpose*],
    [isiZulu], [zul\_train], [zul\_test], [RQ1: monolingual detection],
    [English], [eng\_train], [eng\_test], [English baseline],
    [Combined], [combined\_train], [combined\_test], [Multilingual detection],
    [Cross-lingual], [eng\_train], [zul\_test], [RQ2: transfer learning],
  ),
  caption: [Experimental configurations for MGT detection.],
) <tab:configs>

The cross-lingual configuration is the most challenging: the model is trained exclusively on English data and evaluated on isiZulu text, testing whether detection patterns learned from English generalise across languages.

== Evaluation Metrics

We report accuracy, macro-averaged F1, macro-averaged precision, macro-averaged recall, and area under the ROC curve (AUC-ROC). We use macro averaging to weight both classes equally regardless of any minor class imbalance. We also report a majority-class baseline for comparison.

== LIME Explainability

We apply LIME to the isiZulu-trained model and the cross-lingual model (English-trained, applied to isiZulu). For each model, we generate explanations for 5 human-written and 5 machine-generated isiZulu test samples, extracting the top 12 most influential tokens per sample. We aggregate token weights across samples to identify consistent patterns and compare feature overlap between models using Jaccard similarity on the top-20 features.

// ============================================================
= Experiments and Results

== Overall Performance

@tab:results presents test set performance across all configurations. AfroXLMR achieves strong performance across all monolingual settings, with the cross-lingual configuration showing the expected degradation.

#figure(
  table(
    columns: 6,
    [*Model*], [*Config*], [*Accuracy*], [*F1*], [*Precision*], [*ROC-AUC*],
    [AfroXLMR], [isiZulu], [0.975], [0.975], [0.976], [0.995],
    [AfroXLMR], [English], [0.995], [0.995], [0.995], [1.000],
    [AfroXLMR], [Combined], [0.985], [0.985], [0.986], [0.995],
    [AfroXLMR], [Cross-lingual], [0.754], [0.737], [0.836], [0.985],
    [XLM-R], [isiZulu], [0.941], [0.941], [0.947], [0.993],
    [XLM-R], [English], [0.995], [0.995], [0.995], [1.000],
    [XLM-R], [Combined], [0.983], [0.983], [0.984], [0.995],
    [XLM-R], [Cross-lingual], [0.542], [0.417], [0.762], [0.973],
    [Majority], [All], [0.502], [0.334], [---], [---],
  ),
  caption: [Test set results across all configurations. Majority baseline uses the most frequent class label.],
) <tab:results>

== RQ1: Monolingual isiZulu Detection

AfroXLMR achieves an F1 score of 0.975 on isiZulu-only detection, demonstrating that fine-tuned transformers can reliably distinguish human-written from machine-generated isiZulu text. This is only marginally below the English result (F1 = 0.995), suggesting that despite isiZulu being a lower-resource language, the combination of AfroXLMR's African language pretraining and supervised fine-tuning provides highly effective detection.

The combined configuration (F1 = 0.985) performs between the two monolingual settings, indicating that training on both languages simultaneously does not degrade performance on either language and may provide slight regularisation benefits.

All monolingual configurations substantially outperform the majority-class baseline (F1 = 0.334), confirming that the models learn meaningful detection patterns rather than exploiting class distribution.

== RQ2: Cross-Lingual Transfer

The cross-lingual configuration (train on English, test on isiZulu) achieves F1 = 0.737, representing a 24.4 percentage point drop from monolingual isiZulu detection. This confirms that while some detection signal transfers across languages, the transfer is substantially incomplete.

Notably, the ROC-AUC remains high at 0.985 even in the cross-lingual setting, indicating that the model's ranking ability is preserved — it can generally distinguish more machine-like from more human-like text — but the optimal decision threshold differs between languages. The precision (0.836) is considerably higher than recall (0.752), suggesting the cross-lingual model is conservative: when it predicts machine-generated, it is usually correct, but it misses many machine-generated samples by classifying them as human.

This asymmetry likely reflects morphological differences between English and isiZulu. Machine-generated English text exhibits patterns (e.g., formulaic transitions, uniform sentence length) that partially transfer, but isiZulu-specific indicators (e.g., incorrect noun class agreement, unnatural agglutination patterns) are invisible to an English-trained model.

== LIME Analysis

We apply LIME to both AfroXLMR and XLM-R models in the isiZulu and cross-lingual configurations. @tab:lime_afro presents the top tokens driving machine-text predictions for AfroXLMR, and @tab:lime_xlmr for XLM-R.

#figure(
  table(
    columns: 3,
    [*Config*], [*Top Machine-Indicative Tokens (AfroXLMR)*], [*Avg Weight*],
    [isiZulu], [Enye, Ngakho, siphele, Lokhu, nezingaqinisekisiwe], [0.17–0.25],
    [Cross-lingual], [Ngakho, Inhloso, izinselelo, siphele, emphakathini], [0.13–0.24],
  ),
  caption: [Top LIME tokens indicating machine-generated text (AfroXLMR).],
) <tab:lime_afro>

#figure(
  table(
    columns: 3,
    [*Config*], [*Top Machine-Indicative Tokens (XLM-R)*], [*Avg Weight*],
    [isiZulu], [ASIDI, okuhloselwe, ukuba, nezifo, Kubalulekile], [0.13–0.23],
    [Cross-lingual], [Kubalulekile, ezitholakala, izindleko, ungakwazi, lokuphila], [0.02–0.03],
  ),
  caption: [Top LIME tokens indicating machine-generated text (XLM-R).],
) <tab:lime_xlmr>

A striking difference emerges between the two models' cross-lingual behaviour. AfroXLMR's cross-lingual model maintains strong feature weights (0.13–0.24), comparable to its monolingual isiZulu model (0.17–0.25). In contrast, XLM-R's cross-lingual model shows dramatically weaker signal (0.02–0.03), an order of magnitude lower than its monolingual counterpart (0.13–0.23). This explains the performance gap: AfroXLMR's African language pretraining enables it to identify meaningful isiZulu features even when trained on English, while XLM-R resorts to near-random feature reliance.

The AfroXLMR isiZulu model relies on discourse markers (_Ngakho_ "therefore", _Lokhu_ "this", _Enye_ "another") and formal vocabulary (_nezingaqinisekisiwe_ "unconfirmed", _emphakathini_ "in the community") — words characteristic of the formulaic register that Gemma 4 produces. The AfroXLMR cross-lingual model identifies similar features (_Ngakho_, _siphele_, _emphakathini_), with a Jaccard similarity of 4/20 = 0.20 between the top-12 tokens of the two configurations. This moderate overlap confirms that AfroXLMR's cross-lingual representations partially capture isiZulu-specific detection patterns even without isiZulu training data.

For XLM-R, the cross-lingual model assigns negative weights to several tokens (_ngamanani_, _ikwazi_, _intengo_), incorrectly associating them with human text. The Jaccard similarity between XLM-R's isiZulu and cross-lingual top-12 tokens is 1/23 = 0.043, confirming fundamentally different — and in the cross-lingual case, ineffective — detection strategies.

// ============================================================
= Discussion

Our results demonstrate that AfroXLMR provides highly effective MGT detection for isiZulu (F1 = 0.975), approaching the performance achieved on English (F1 = 0.995). This finding is significant because it shows that African language-adapted transformers can be successfully applied to the emerging challenge of MGT detection, even with relatively small training sets (~950 samples).

Comparing AfroXLMR to XLM-R reveals the value of African language specialisation. On isiZulu, AfroXLMR outperforms XLM-R by 3.4 F1 points (0.975 vs 0.941), while on English both models achieve identical performance (0.995). The gap widens dramatically in the cross-lingual setting: AfroXLMR achieves F1 = 0.737 compared to XLM-R's 0.417, which barely exceeds the majority baseline (0.334). This 32-point difference demonstrates that AfroXLMR's additional African language pretraining provides substantially better cross-lingual representations for isiZulu.

Error analysis reveals an asymmetry in failure modes. In monolingual settings, both models produce predominantly false positives — misclassifying human text as machine-generated — while never missing actual machine text. In the cross-lingual setting, the pattern reverses entirely: XLM-R produces 93 false negatives and zero false positives, indicating it cannot recognise machine-generated isiZulu and defaults to predicting human.

The cross-lingual transfer gap (0.975 → 0.737 for AfroXLMR; 0.941 → 0.417 for XLM-R) highlights a key limitation: detection models trained on English cannot simply be deployed for isiZulu without significant performance loss. This has practical implications for content moderation and academic integrity systems that may assume English-trained detectors generalise to other languages. For agglutinative languages like isiZulu, language-specific training data and models appear necessary.

The high ROC-AUC in the cross-lingual setting (0.985 for AfroXLMR, 0.973 for XLM-R) suggests an interesting middle ground: while the default threshold performs poorly, a calibrated threshold could potentially improve cross-lingual detection without requiring isiZulu training data. This warrants further investigation.

*Limitations.* Our study has several limitations: (1) we use a single generator (Gemma 4), and detection performance may differ for text generated by other LLMs; (2) our dataset is relatively small compared to English MGT detection benchmarks; (3) the human text sources (Vukuzenzele, Wikipedia) have distinct stylistic properties that may simplify the detection task; and (4) LIME explanations are approximations and may not fully capture the model's decision process for subword-tokenised text.

// ============================================================
= Conclusion

We present the first evaluation of transformer-based machine-generated text detection for isiZulu. Fine-tuned AfroXLMR achieves F1 = 0.975 on monolingual isiZulu detection, demonstrating that effective MGT detection is achievable for low-resource African languages with appropriate model selection and modest training data. Cross-lingual transfer from English yields F1 = 0.737, confirming that while some detection signal is language-agnostic, language-specific training remains essential for reliable deployment.

Our LIME analysis reveals that monolingual and cross-lingual models employ fundamentally different detection strategies, with the isiZulu model leveraging morphological features absent from the cross-lingual model's repertoire. Crucially, AfroXLMR maintains meaningful feature weights in cross-lingual transfer (0.13–0.24) while XLM-R collapses to near-random signal (0.02–0.03), explaining the 32-point F1 gap between the two models' cross-lingual performance.

Future work should evaluate detection across multiple generators, extend to additional African languages, investigate threshold calibration for cross-lingual deployment, and explore few-shot adaptation as a middle ground between full monolingual training and zero-shot transfer.

#bibliography("references.bib")

