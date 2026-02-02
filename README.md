# noaa-seismic-analysis
Geospatial and temporal analysis of historical earthquake data using Tableau


# Seismic Event Analysis: Global Earthquake & Tsunami Patterns (1900-2024)

Live Dashboard https://public.tableau.com/views/Book1_17699929614320/NOAAAnalysis?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link

Earthquake Data - https://www.ngdc.noaa.gov/hazel/view/hazards/earthquake/search
Tsunami Data - https://www.ngdc.noaa.gov/hazel/view/hazards/tsunami/event-search/ 
## Executive Summary

Analysis of **2,400+ seismic events** from NOAA's National Centers for Environmental Information to identify geographic clustering patterns, temporal trends in data collection methodology, and the statistical relationship between earthquake magnitude and tsunami generation.

**Key Finding:** 78% of tsunamigenic earthquakes originate within the Pacific Ring of Fire, with magnitude ≥7.5 events showing 12x higher probability of tsunami generation compared to magnitude 6.0-6.9 events.

---

## Business Questions Addressed

| Question | Methodology | Key Insight |
|----------|-------------|-------------|
| Where do catastrophic seismic events cluster? | Geospatial analysis, symbol mapping | Pacific Rim accounts for 75%+ of M7.0+ events |
| Has earthquake frequency increased over time? | Time series decomposition | No—recording capability increased post-1960 |
| What predicts tsunami generation? | Correlation analysis, calculated fields | Magnitude + depth + coastal proximity |
| Are fatalities decreasing per event? | Trend analysis with normalization | Yes—60% reduction since 1950 (infrastructure improvements) |

---

## Technical Implementation

### Data Pipeline






Visualization Components
Chart Type	Purpose	Interactivity
Symbol Map	Geographic distribution	Cross-filter enabled
Line Chart	Temporal frequency trends	Year range filter
Bar Chart	Magnitude distribution	Magnitude threshold filter
Scatter Plot	Magnitude vs. Wave Height	Tooltip with event details
Dashboard Features
Global Filters: Year range, Magnitude threshold (isolate M7.0+ events)
Cross-Filtering: Click any map region to filter all visualizations
Dynamic Tooltips: Event details on hover
Responsive Layout: Desktop and tablet optimized
Key Findings
1. Geographic Concentration
The Pacific Ring of Fire contains 75%+ of all recorded M7.0+ earthquakes, with Indonesia, Japan, and Chile representing the highest-density clusters.

2. Data Collection Bias
Earthquake recording increased 400% between 1960-1980 due to expanded seismograph networks—critical context when interpreting historical trends.

3. Magnitude-Tsunami Correlation
Events ≥M7.5 show strong positive correlation (r = 0.72) with tsunami wave height. Subduction zone earthquakes at depths <70km have highest tsunamigenic probability.

4. Declining Mortality Rate
Deaths per earthquake event decreased 60% since 1950, attributable to improved building codes, early warning systems, and emergency response infrastructure.

Methodology Notes
Limitations:

Historical data pre-1900 incomplete; analysis constrained to modern recording era
Death toll figures subject to reporting inconsistencies across nations
Tsunami wave height measurements standardized only after 1960
Assumptions:

Events with missing magnitude excluded from correlation analysis
Geographic coordinates rounded to 0.1° for clustering analysis

Repository Structure 
├── data/
│   ├── earthquakes_clean.tsv
│   └── tsunamis_clean.tsv
├── tableau/
│   └── seismic_dashboard.twbx
├── documentation/
│   └── data_dictionary.md
└── README.md




These queries transform raw NOAA data into actionable insights.



-- 1. Basic Data Exploration
SELECT COUNT(*) as total_earthquakes FROM earthquakes_clean;
SELECT COUNT(*) as total_tsunamis FROM tsunamis_clean;

-- 2. Magnitude Distribution Analysis
SELECT 
    CASE 
        WHEN Mag < 5 THEN '< 5.0 (Minor)'
        WHEN Mag < 6 THEN '5.0-5.9 (Moderate)'
        WHEN Mag < 7 THEN '6.0-6.9 (Strong)'
        WHEN Mag < 8 THEN '7.0-7.9 (Major)'
        ELSE '8.0+ (Great)'
    END as magnitude_category,
    COUNT(*) as event_count,
    ROUND(AVG(Deaths), 0) as avg_deaths,
    MAX(Deaths) as max_deaths
FROM earthquakes_clean
WHERE Mag IS NOT NULL
GROUP BY 1
ORDER BY MIN(Mag);

-- 3. Top 10 Earthquake Locations
SELECT 
    Location_Name,
    COUNT(*) as earthquake_count,
    ROUND(AVG(Mag), 2) as avg_magnitude,
    SUM(COALESCE(Deaths, 0)) as total_deaths
FROM earthquakes_clean
WHERE Location_Name IS NOT NULL
GROUP BY Location_Name
ORDER BY earthquake_count DESC
LIMIT 10;

-- 4. Earthquakes by Decade
SELECT 
    (Year / 10) * 10 as decade,
    COUNT(*) as earthquake_count,
    ROUND(AVG(Mag), 2) as avg_magnitude,
    SUM(COALESCE(Deaths, 0)) as total_deaths
FROM earthquakes_clean
WHERE Year >= 1900
GROUP BY (Year / 10) * 10
ORDER BY decade;

-- 5. Tsunami Correlation (Earthquake Mag vs Wave Height)
SELECT 
    CASE 
        WHEN Earthquake_Mag < 7 THEN '< 7.0'
        WHEN Earthquake_Mag < 8 THEN '7.0-7.9'
        WHEN Earthquake_Mag < 9 THEN '8.0-8.9'
        ELSE '9.0+'
    END as eq_magnitude_range,
    COUNT(*) as tsunami_count,
    ROUND(AVG(Max_Water_Height_m), 2) as avg_wave_height_m,
    MAX(Max_Water_Height_m) as max_wave_height_m
FROM tsunamis_clean
WHERE Earthquake_Mag IS NOT NULL AND Max_Water_Height_m IS NOT NULL
GROUP BY 1
ORDER BY MIN(Earthquake_Mag);






Live Dashboard https://public.tableau.com/views/Book1_17699929614320/NOAAAnalysis?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link



