---Deadliest earthquakes by decade
SELECT (Year / 10) * 10 AS Decade, SUM(Deaths) AS Total_Deaths
FROM earthquakes_clean
GROUP BY Decade ORDER BY Total_Deaths DESC;

---Top 10 Locations
SELECT Location_Name, COUNT(*), AVG(Mag), SUM(Deaths), MAX(Mag)
FROM earthquakes_clean GROUP BY Location_Name ORDER BY earthquake_count DESC LIMIT 10;


-- Distribution of earthquake magnitudes
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



-- Deadliest years
SELECT 
    Year,
    COUNT(*) as earthquake_count,
    SUM(COALESCE(Deaths, 0)) as total_deaths,
    MAX(Mag) as max_magnitude
FROM earthquakes_clean
WHERE COALESCE(Deaths, 0) > 0
GROUP BY Year
ORDER BY total_deaths DESC
LIMIT 10;



-- Tsunamis by cause
SELECT 
    Cause_Code,
    CASE Cause_Code
        WHEN 1 THEN 'Earthquake'
        WHEN 2 THEN 'Questionable Earthquake'
        WHEN 3 THEN 'Volcano'
        WHEN 4 THEN 'Landslide'
        WHEN 5 THEN 'Explosion'
        WHEN 6 THEN 'Meteorological'
        ELSE 'Other/Unknown'
    END as cause,
    COUNT(*) as tsunami_count,
    ROUND(AVG(Max_Water_Height_m), 2) as avg_wave_height_m,
    MAX(Max_Water_Height_m) as max_wave_height_m,
    SUM(COALESCE(Total_Deaths, 0)) as total_deaths
FROM tsunamis_clean
GROUP BY Cause_Code
ORDER BY tsunami_count DESC;
