#  KBIZ 중소기업중앙회 : 공간정보를 활용한 중소기업 기본 통계 분석(2022) 
* **전국 중소기업 데이터를 바탕으로 중소기업 기본 통계 분석을 진행.**

* **2015년부터 2020년까지 중소기업 밀집지역 및 성장, 소멸 지역을 지도로 시각화.**

<br>

**Directory Structure**

```text
sme-basic-stats/
├── 📂 R/ # 핵심 분석 코드
│ ├── 1_전처리.R # [Step 1] 데이터 전처리
│ ├── 2_shp결합.R # [Step 2] 공간 데이터 결합
│ └── 3_공간통계.R # [Step 3] 공간통계 분석 및 시각화
│
├── 📜 Data_Preprocessing.R # 데이터 전처리 스크립트
├── 📜 test.R # 테스트 스크립트
├── 📜 test2.R # 테스트 스크립트 (2)
└── 📜 README.md # 프로젝트 설명서
 ```

<br>

### [밀집지역 탐색 방법론]

공간 통계 기법을 활용하여 중소기업 매출 및 분포의 공간적 패턴을 분석하고 시각화.


 1. 공간 자기상관성 분석 (Spatial Autocorrelation)
* **Local Moran's I (LISA):**
    * 전역적(Global) 모란지수가 가지는 분포 패턴 확인의 한계를 보완하기 위해 사용하였습니다.
    * 공간 가중 행렬(Spatial Weight Matrix)을 기반으로 특정 지역과 인접 지역 간의 속성 데이터 유사성을 측정하여, 국지적인 군집(Cluster) 지역과 이상치(Outlier)를 식별합니다.

2. 핫스팟 분석 (Hotspot Analysis)
* **Getis-Ord Local $G_i^*$ Statistic:**
    * 특정 현상의 발생 빈도가 높은 공간 단위가 국지적으로 군집을 이루는지(Hotspot) 검정합니다.
    * $G_i^*$ Z-score를 산출하여 통계적 유의성을 확보한 군집 지역을 도출하였습니다.
    * **임계치 기준:**
        * $Z \ge 1.96$: 95% 신뢰수준에서 유의한 핫스팟
        * $Z \ge 2.58$: 99% 신뢰수준에서 유의한 핫스팟

3. 데이터 시각화 (Visualization)
* 매출액 등 데이터의 왜도(Skewness)를 고려하여 세 가지 분류 방식(**Quantile, Jenks, Equal Interval**)을 비교 분석하였습니다.
* 이를 통해 단순 순위뿐만 아니라 실제 경제력 집중 현상을 다각도로 시각화하였습니다.


<br>

**Simulation Flowchart**

```text
[Raw Data (.txt)]
       │
       ▼
1. 1_전처리.R ──────────────────────────┐
       │                                │
       │ (Output: df.csv)               │ 행정동별 매출액/종사자 수 집계
       │                                │
       ▼                                │
2. 2_shp결합.R ──────────────────────────┤
       │                                │
       │ (Input: bnd_dong.shp)          │ 통계 데이터 + 지도(Shapefile) 결합
       │ (Output: merge2.shp)           │
       │                                │
       ▼                                │
3. 3_공간통계.R ──────────────────────────┘
       │
       ├── Visualization (지도 시각화: Quantile/Jenks/Equal)
       ├── Moran's I (공간 자기상관성 검증)
       └── Hotspot Analysis (핫스팟/콜드스팟 도출)
```

<br>

### [밀집지역 핫스팟과 콜드스팟]

<img width="423" height="546" alt="image" src="https://github.com/user-attachments/assets/2c40eeb2-4bee-4c94-bfbd-3a8c946530bc" />


<br>

### [분류방법에 따른 기업체 매출액]

<img width="1096" height="323" alt="image" src="https://github.com/user-attachments/assets/e7bec11d-dbc6-42af-b49b-f44137262eb6" />

* **style = "quantile"**

등분위 분류 (Quantile) : 전체 기업을 20%씩 나눠 순위로 분류를 진행

* **style = "jenks"**

자연적 분류 (Jenks) : 데이터 간의 격차가 급격히 벌어지는 구간을 찾아 분류를 진행

* **style = "equal"**

등간격 (Equal Interval) : 전체 기업의 매출을 똑같은 간격 5개로 나눠 분류를 진행
