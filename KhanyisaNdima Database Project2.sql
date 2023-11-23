Create database Mybooks;
use Mybooks;

-- Select all from the tables.
select*from books;
select*from author_table;
select*from book_table;

-- Find the author who has written the most books in the database.
select author_table.authors, count(book_table.bookID) AS num_books
from author_table
join book_table on author_table.title = book_table.title
group by author_table.authors
order by num_books DESC
LIMIT 1;

-- Calculate the total number of pages written by each author and list the authors in descending order of their total page count.
Select authors, sum(num_pages) AS Total_Pages
From book_table,author_table
group by authors
order by Total_Pages DESC;

-- From books table take ‘average rating’ and put it into author table.
-- alter author table
alter table author_table add column Average_Rating decimal(6,2);

update author_table
join books on author_table.title = books.title
set author_table.average_rating = books.average_rating;

-- List the book titles that are available in more than one language.
select title 
from author_table
group by author_table.title
having count(distinct language_code) > 1;

-- This will give you the year with the highest average page count.
WITH AveragePagesByYear AS (SELECT publication_date, AVG(num_pages) AS avg_page_count
    FROM author_table,book_table
    GROUP BY publication_date)
SELECT publication_date, avg_page_count
FROM AveragePagesByYear
WHERE avg_page_count = (SELECT MAX(avg_page_count) FROM AveragePagesByYear);
    
-- This will identify the publisher with the most books published in a language other than English.
 SELECT publisher, language_code, COUNT(*) AS book_count
FROM book_table,author_table
WHERE language_code <> 'English'
GROUP BY publisher, language_code
HAVING COUNT(*) = (SELECT MAX(book_count)FROM (SELECT publisher, language_code, COUNT(*) AS book_count
            FROM book_table,author_table
            WHERE language_code <> 'English'
            GROUP BY publisher, language_code) AS Subquery);
    


    
    
