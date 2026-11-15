# 🌩️ Storm Radiance & Power Outage Analytics (28.93M+ Records)

**Zero-Cost R Tidyverse ETL & Tableau BI Architecture on Resource-Constrained Hardware (4GB RAM)**

[![R](https://img.shields.io/badge/R-4.6.1-276DC3?style=flat&logo=r&logoColor=white)](https://www.r-project.org/)
[![Tidyverse](https://img.shields.io/badge/ETL-Tidyverse-1A162D?style=flat)](https://www.tidyverse.org/)
[![Tableau](https://img.shields.io/badge/BI-Tableau%20Public-E97627?style=flat&logo=tableau&logoColor=white)](https://public.tableau.com/)
[![Hardware](https://img.shields.io/badge/RAM%20Ceiling-4GB%20Local-success?style=flat)]()

## 📌 Project Overview
This project demonstrates an end-to-end, memory-safe Big Data engineering and Business Intelligence pipeline capable of ingesting, cleaning, and aggregating **28,933,703 raw satellite radiance telemetry records** into **611 distinct disaster event profiles** (`event_id`)—executed 100% locally without cloud infrastructure (`$0` compute cost).

By applying early filtering, strict data-type casting, and vector-based grouping in R, peak workspace memory consumption was capped at just **396 MiB**, well within a strict ~2.0 GB usable RAM ceiling.

---

## 💻 Machine Specs & System Constraints
Designed to prove enterprise-grade data engineering efficiency under tight hardware limits:

| Component | Specification | Operational Constraint |
| :--- | :--- | :--- |
| **Processor** | Intel Core i3 (1.2 GHz) | Entry-level dual-core CPU |
| **Total System RAM** | 4.0 GB Physical Memory | Strict hardware memory ceiling |
| **Operating System** | Windows 10 (~2.0 GB Overhead) | Leaves **~2.0 GB** free workspace RAM |
| **Cloud / Compute Cost** | $0.00 (100% Offline Local Execution) | Zero external server or cloud dependencies |
| **Peak Pipeline RAM** | **396 MiB** | **~80% headroom** preserved below workspace limit |

---

## 🏗️ System Architecture: Data Pipeline Flow

```text
┌─────────────────────────────┐
│   1. Raw CSV Ingestion      │  28,933,703 raw telemetry rows (13 variables)
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│   2. Tidy Cleaning & Cast   │  Deduplication, integer/numeric casting, & 
│                             │  positive sensor signal filtering (> 0)
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│   3. Event Aggregation      │  99.99% row compression: grouped into 611 
│                             │  unique disaster events (396 MiB RAM footprint)
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│   4. Tableau BI Visuals     │  Lightweight CSV exported to Tableau Hyper 
│                             │  Extract for interactive KPI & treemap analysis
└─────────────────────────────┘
```

### R Pipeline Architecture Description
1. **Type Standardization:** Explicitly casts `valid_pixels` to `integer` and `light_ratio` to `numeric` to eliminate bloated character/float memory overhead.
2. **Positive Signal Filter:** Removes zero-value, null, or corrupted satellite sensor readings (`valid_pixels > 0 & light_ratio > 0`), reducing valid analytical records to **23.32M**.
3. **Disaster Event Grouping:** Compresses millions of granular sensor observations into aggregated summary profiles per `event_id` (`Avg_Valid_Pixels`, `Avg_light_ratio`, `Total_Records`), outputting a compact 611-row CSV ready for instant Tableau rendering.

---

## ⚙️ R ETL Pipeline Code

```r
library(tidyverse)
library(readr)

# Execute memory-safe ETL pipeline on 28.93M raw storm records
final_storm_analized_28M_record_data <- data_raw %>%
  distinct() %>% 
  mutate(
    valid_pixels = as.integer(valid_pixels),
    light_ratio  = as.numeric(light_ratio)
  ) %>%
  filter(valid_pixels > 0 & light_ratio > 0) %>%
  group_by(event_id) %>% 
  summarise(
    Avg_Valid_Pixels = mean(valid_pixels),
    Avg_light_ratio  = mean(light_ratio),
    Total_Records    = n(), 
    .groups = 'drop'
  ) %>%
  arrange(Total_Records)

# Inspect aggregated tibble in console
final_storm_analized_28M_record_data

# Export lightweight dataset for Tableau ingestion
write.csv(
  final_storm_analized_28M_record_data,
  "Storm_28M_record_data.csv",
  row.names = FALSE
)
```

---

## 🖥️ Live R Console Telemetry & Environment Proof
Verified execution in **R 4.6.1 (RStudio)**:
* **Global Environment State:**
  * `data_raw`: `28,933,703 obs. of 13 variables`
  * `final_storm_analized_28M_record_data`: `611 obs. of 4 variables`
  * **Active Memory Meter:** `396 MiB`

```text
> final_storm_analized_28M_record_data
# A tibble: 611 × 4
   event_id Avg_Valid_Pixels Avg_light_ratio Total_Records
   <chr>               <dbl>           <dbl>         <int>
 1 DR-4073              812.           0.990           214
 2 DR-4260              793.           0.995           350
 3 DR-4062             9647.           1.45           1022
 4 DR-4265             6293.           1.11           1351
 5 DR-4916             6107.           1.05           1393
 6 DR-4212             2018.           0.982          2010
 7 DR-4107             2048.           0.928          2041
 8 DR-4766             2231.           1.03           2044
 9 DR-4765             2275.           1.01           2073
10 DR-4653             2114.           1.00           2091
# ℹ 601 more rows
```

---

## 📊 Tableau Dashboard Metrics & Top Events

### Executive KPI Summary
* **Total Raw Records Ingested:** `28,933,703` (28.93M)
* **Cleaned Valid Records:** `23.32M`
* **Unique Disaster Events:** `611` (`DR` profiles)
* **Cumulative Avg Valid Pixels:** `5.50M` (`5,497,113`)
* **Overall Avg Light Ratio:** `894.6` (cumulative index) / `1.45` (peak event stability)

### Top Storm Events by Valid Pixel Coverage
| Disaster Event ID | Avg Valid Pixels | Avg Light Ratio | Record Volume |
| :--- | :--- | :--- | :--- |
| **DR-4620** (Overall Peak Coverage) | **82,642 px** | — | High-density spatial cluster |
| **DR-4203** | **80,383 px** | — | High-density spatial cluster |
| **DR-4307** | **62,680 px** | — | High-density spatial cluster |
| **DR-4708** | **62,338 px** | — | High-density spatial cluster |
| **DR-4303** | **60,633 px** | — | High-density spatial cluster |
| **DR-4062** (High Radiance Stability) | **9,647 px** | **1.45** | 1,022 records |
| **DR-4265** | **6,293 px** | **1.11** | 1,351 records |
| **DR-4916** | **6,107 px** | **1.05** | 1,393 records |

---

## 💡 Actionable Business & Policy Insights
1. **Outage Severity Targeting:** Disaster events registering an `Avg_light_ratio` below `1.0` (such as `DR-4107` at `0.928` and `DR-4212` at `0.982`) serve as early-warning indicators of severe power grid blackouts, enabling emergency response teams to prioritize rapid restoration dispatch.
2. **Spatial Coverage Priority:** Events exhibiting exceptionally high `Avg_Valid_Pixels` (e.g., `DR-4620` at `82,642 px` and `DR-4203` at `80,383 px`) validate wide-area geographic impact zones where utility infrastructure auditing should be concentrated first.
3. **Zero-Cloud BI Scalability:** Pre-aggregating 28.93M raw telemetry rows locally into a 611-row summary table before Tableau Hyper ingestion eliminates visualization lag and saves thousands of dollars in cloud data warehouse compute costs.

---

## 👨‍💻 Developer & Connect

**Niaz Mohammad Shoyab**  
*Data Analyst & Big Data Pipeline Engineer*

* 🔗 **LinkedIn:** [linkedin.com/in/niaz-shoyab-495061b8](https://www.linkedin.com/in/niaz-shoyab-495061b8)
* 💻 **GitHub:** [github.com/talkmriul-bit](https://github.com/talkmriul-bit)
* 📧 **Email:** [talkmridul@gmail.com](mailto:talkmridul@gmail.com)