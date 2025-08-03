create database youtube_analyzer;
use youtube_analyzer;

CREATE TABLE channels (
    channel_id VARCHAR(50) PRIMARY KEY,
    channel_name VARCHAR(100),
    subscribers INT,
    total_views BIGINT,
    total_videos INT
);

CREATE TABLE videos (
    video_id VARCHAR(50) PRIMARY KEY,
    channel_id VARCHAR(50),
    title TEXT,
    published_date DATE,
    views BIGINT,
    likes INT,
    comments INT,
    FOREIGN KEY (channel_id) REFERENCES channels(channel_id)
);

INSERT INTO channels VALUES 
('UC123456', 'Tech World', 1000000, 50000000, 100);

INSERT INTO videos VALUES
('vid001', 'UC123456', 'How to code in Python', '2023-01-15', 200000, 5000, 800),
('vid002', 'UC123456', 'SQL Tutorial', '2023-02-10', 150000, 4000, 500),
('vid003', 'UC123456', 'Data Science Basics', '2023-03-05', 300000, 7000, 1200);

select count(*) as total_videos,sum(views) as total_views
from videos
where channel_id='UC123456';

select title,views
from videos
where channel_id='UC123456'
order by views desc
limit 1;

select round(avg(likes),2) as avg_likes,
round(avg(comments),2)as avg_comments
from videos
where channel_id='UC123456';

select date_format(published_date,'%y-%m') as month,
count(*) as video_count
from videos
where channel_id='UC123456'
group by month
order by month;

select title,
round(((likes+comments)/views)*100,2) as
engagement_rate
from videos
where channel_id='UC123456';

select title,likes
from videos
where channel_id='UC123456'
order by likes desc
limit 5;

select date_format(published_date,'%y-%m') as month,
count(*) as videos_uploaded
from videos
where channel_id='UC123456'
group by month
order by videos_uploaded desc
limit 3;

select title,likes,comments
from videos
where channel_id='UC123456'
and comments<likes;

SELECT 
    title,
    published_date,
    views,
    SUM(views) OVER (ORDER BY published_date) AS running_total_views
FROM videos
WHERE channel_id = 'UC123456';

SELECT 
    DATE_FORMAT(published_date, '%Y-%m') AS month,
    ROUND(AVG(views), 2) AS avg_views
FROM videos
WHERE channel_id = 'UC123456'
GROUP BY month
ORDER BY month;

SELECT * FROM (
    SELECT 
        title,
        views,
        DATE_FORMAT(published_date, '%Y-%m') AS month,
        RANK() OVER (PARTITION BY DATE_FORMAT(published_date, '%Y-%m') ORDER BY views DESC) AS ranks
    FROM videos
    WHERE channel_id = 'UC123456'
) AS ranked
WHERE ranks = 1;

SELECT 
    ROUND(AVG(gap_days), 2) AS avg_upload_gap
FROM (
    SELECT 
        video_id,
        DATEDIFF(published_date, LAG(published_date) OVER (ORDER BY published_date)) AS gap_days
    FROM videos
    WHERE channel_id = 'UC123456'
) AS gaps
WHERE gap_days IS NOT NULL;

SELECT 
    title,
    views,
    comments,
    ROUND((comments * 1000.0) / views, 2) AS comments_per_1000_views
FROM videos
WHERE channel_id = 'UC123456'
ORDER BY comments_per_1000_views DESC
LIMIT 1;

WITH like_view_avg AS (
    SELECT AVG(likes * 1.0 / views) AS avg_ratio
    FROM videos
    WHERE channel_id = 'UC123456')
SELECT 
    title,
    likes,
    views,
    ROUND(likes * 1.0 / views, 4) AS like_view_ratio
FROM videos, like_view_avg
WHERE (likes * 1.0 / views) > like_view_avg.avg_ratio;