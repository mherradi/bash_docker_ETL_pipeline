# Data Maroc Boot Camps Lab 2 — Bash & Docker ETL Pipeline
&nbsp;&nbsp;&nbsp;This project models a simple file based ETL pipeline built with Bash & Docker that processes sales and product return files, calculates daily sales totals, aggregates returns by **city and reason**, archives handled files, and records operational logs.
&nbsp;
&nbsp;

##  Tools and Platforms :
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=flat&logo=gnubash&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![Alpine Linux](https://img.shields.io/badge/Alpine_Linux-0D597F?style=flat&logo=alpinelinux&logoColor=white)
![GNU AWK](https://img.shields.io/badge/GNU_AWK-555555?style=flat&logo=gnu&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=flat&logo=linux&logoColor=black)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=flat&logo=docker&logoColor=white)
![ETL Pipeline](https://img.shields.io/badge/ETL-Pipeline-2E8B57?style=flat)
![CSV Processing](https://img.shields.io/badge/CSV-Processing-00897B?style=flat)
![Automation](https://img.shields.io/badge/Processing-Automated-orange?style=flat)

&nbsp;

&nbsp;
## Architecture Overview
This project models a simple ETL architecture (Extract, Transform, Load) workflow:
&nbsp;
<img width="1672" height="941" alt="Pipeline ETL Ventes et Retours" src="https://github.com/user-attachments/assets/652afacf-54dd-4cd8-8210-e078e4665352" />
## 🔬 The lab in one picture
```text
CSV sources
    |
    +-- data/incoming/*.csv ------> Sales processing ------> data/result/report_YYYY-MM-DD.csv
    |                                      |
    |                                      +---------------> data/archive/sales_*.csv
    |
    +-- data/returns/*.csv -------> Returns processing ----> data/output/report.csv
    |                                      |
    |                                      +---------------> data/archive/returns_*.csv
    |
    +-- data/incoming/*.temp -----> data/trash/

```
&nbsp;
## Project Files :

```text
bash_docker_ETL_pipeline/
├── README.md
├── processing.sh                  # Bash pipeline script
├── Dockerfile                     # container definition (example below)
├── compose.yaml                   # optional Compose configuration
├── incoming/                      # incoming sales CSVs
├── returns/                       # incoming return CSVs
├── result/                        # daily sales reports
├── output/                        # daily return-count reports
├── archive/                       # accepted input files
├── errors/                        # rejected files
├── trash/                         # incoming .temp files
└── logs/                          # execution logs
└── data/                          # simple of incoming data to use for test purposes

```

The Bash script uses **relative paths**, so run it from the directory containing `incoming/`, `returns/`, and the other runtime folders. In the Docker setup below, that directory is `/data`.

## Run the lab : 

To ensure structured execution, orchestration notebooks were implemented for each layer. Each orchestration notebook acts as a single entry point, validating dependencies and executing transformations in the correct order.
&nbsp;

```bash
cd Lesson_2_bash_and_docker/Labs
docker compose up -d --build      # start processor + viewer
docker compose logs -f processor  # watch the script work
# open http://localhost:8080
docker compose down               # stop and remove everything
```
&nbsp;

## BONUS Question :
```text
Why count with grep -c ",$reason," (commas on both sides) instead of just grep -c "$reason"
-- what exactly does that avoid? 
```

**Answer** : grep searches for the giving expression anywhere in each line, which could produce unpredictable results, and to avoid This behavior we surrounded by commas 
which normally represent expression boundaries. 
