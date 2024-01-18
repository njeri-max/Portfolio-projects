--creating posts table
CREATE TABLE posts(
post_id INT PRIMARY KEY,
post_content TEXT,
post_date DATETIME);

--DROP TABLE posts;

--inserting data into the posts table
INSERT INTO posts(post_id, post_content, post_date)
VALUES
	(1, 'There’s no question that many small business owners should build a 
	presence with Instagram marketing.', '2024-01-25 10:00:00'),

	(2, 'In this post, we’ll look at what to post on Instagram, with ideas and examples 
	you can adapt for your own brand.', '2024-01-26 20:00:00'),

	(3, 'Show off with product posts', '2024-01-27 15:30:00'),

	(4, 'Convert customers with product tags', '2024-01-28 10:20:00'),

	(5, 'Ideally you’re showcasing your products in an aspirational yet relatable setting that your audience 
	can picture themselves in.', '2024-01-29 18:00:00')

	SELECT * 
	FROM [dbo].[posts];

--Creating user reaction table
CREATE TABLE UserReaction (
reaction_id INT PRIMARY KEY,
userR_id INT,
post_id INT,
reaction_date DATETIME,
reaction_type VARCHAR(40),
CHECK(reaction_type IN('Like', 'Share', 'Comment')),
FOREIGN KEY (post_id) REFERENCES posts(post_id),
);

--Inserting Data to the table
INSERT INTO UserReaction(reaction_id, userR_id, post_id, reaction_type, reaction_date)
VALUES
	(1, 101, 1, 'like', '2023-08-25 10:15:00'),
    (2, 102, 1, 'comment', '2023-08-25 11:30:00'),
    (3, 103, 1, 'share', '2023-08-26 12:45:00'),
    (4, 101, 2, 'like', '2023-08-26 15:45:00'),
    (5, 102, 2, 'comment', '2023-08-27 09:20:00'),
    (6, 104, 2, 'like', '2023-08-27 10:00:00'),
    (7, 105, 3, 'comment', '2023-08-27 14:30:00'),
    (8, 101, 3, 'like', '2023-08-28 08:15:00'),
    (9, 103, 4, 'like', '2023-08-28 10:30:00'),
    (10, 105, 4, 'share', '2023-08-29 11:15:00'),
    (11, 104, 5, 'like', '2023-08-29 16:30:00'),
    (12, 101, 5, 'comment', '2023-08-30 09:45:00');
SELECT * 
FROM [dbo].[UserReaction];


--This part retrieves the count of likes, comments and shares from a specific post
SELECT
	p.post_id,
	CAST(p.post_content AS nvarchar(MAX)) AS post_content2,
	COUNT(CASE WHEN ur.reaction_type = 'Like' THEN 1 END) AS num_likes,
	COUNT(CASE WHEN ur.reaction_type = 'Share' THEN 1 END) AS num_share,
	COUNT(CASE WHEN ur.reaction_type = 'Comment' THEN 1 END) AS num_comment
FROM
	posts p
LEFT JOIN 
	UserReaction ur ON p.post_id = ur.post_id
WHERE p.post_id = 4
GROUP BY 
	p.post_id, 
	CAST(p.post_content AS nvarchar(max));

--Caluclating the mean/Average number of reactions surrounding likes, shares and comments per user within a given time period
SELECT
	ur.reaction_date2,
	COUNT(DISTINCT ur.userR_id) AS unique_user,
	COUNT(*) AS all_reactions,
	AVG(COUNT(*)) OVER (PARTITION BY ur.reaction_date2) AS avg_reactions_per_user
FROM 
	UserReaction ur	
WHERE 
	ur.reaction_date2 BETWEEN '2023-08-25' AND '2023-08-30'
GROUP BY
	ur.reaction_date2;

--Removing the 'time-factor' in the date
UPDATE [dbo].[UserReaction]
SET reaction_date = CONVERT(Date, reaction_date);

ALTER TABLE [dbo].[UserReaction]
ADD reaction_date2 Date;

UPDATE [dbo].[UserReaction]
SET reaction_date2 =  CONVERT(Date, reaction_date);

SELECT *
FROM [dbo].[UserReaction];

ALTER TABLE [dbo].[UserReaction]
DROP COLUMN reaction_date;

--Identifying the three most engaging posts
SELECT TOP 3
	p.post_id,
	CAST(p.post_content AS nvarchar(MAX)) AS post_content3,
	SUM(CASE WHEN ur.reaction_type = 'like' THEN 1 ELSE 0 END +
		CASE WHEN ur.reaction_type = 'comment' THEN 1 ELSE 0 END +
		CASE WHEN ur.reaction_type = 'share' THEN 1 ELSE 0 END) AS overall_reactions 
FROM 
	posts p
LEFT JOIN
	UserReaction ur ON p.post_id = ur.post_id
WHERE 
	 ur.reaction_date2 BETWEEN DATEADD(DAY, 4, GETDATE()) AND GETDATE()
GROUP BY
	p.post_id, 
	CAST(p.post_content AS nvarchar(MAX)) 
ORDER BY
	overall_reactions DESC;
		 


