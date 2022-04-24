Drop table rating;
Drop table movie_cast;
Drop table movies;
Drop table director;
Drop table actor;
create table actor
(
	act_id varchar(3),
	act_name varchar(10),
	act_gender varchar(1),
	primary key(act_id)
);

create table director
(
	dir_id varchar(3),
	dir_name varchar(20),
	dir_phone varchar(10),
	primary key(dir_id)
);

create table movies
(
	mov_id varchar(3),
	mov_title varchar(20),
	mov_year int,
	mov_lang varchar(10),
	dir_id varchar(3),
	primary key(mov_id),
	foreign key(dir_id) references director(dir_id) on delete set NULL
);

create table movie_cast
(
	act_id varchar(3),
	mov_id varchar(3),
	role varchar(10),
	primary key(act_id,mov_id),
	foreign key(act_id) references actor(act_id) on delete set NULL,
	foreign key(mov_id) references movies(mov_id) on delete set NULL
);

create table rating
(
	mov_id varchar(3),
	rev_stars int,
	primary key (mov_id,rev_stars),
	foreign key (mov_id) references movies (mov_id) on delete set NULL
);

insert into actor values('a1','robert d','m');
insert into actor values('a2','scarlett','f');
insert into actor values('a3','puneeth','m');
insert into actor values('a4','meera','f');
insert into actor values('a5','prabhas','m');
insert into actor values('a6','anushka','f');

insert into director values('d1','hitchcock','7690870681');
insert into director values('d2','steven spielberg','7986554437');
insert into director values('d3','mahesh babu','8765675304');
insert into director values('d4','rajamouli','9651232245');

insert into movies values('m1','iron man-1',1990,'english','d1');
insert into movies values('m2','munna',1998,'telugu','d3');
insert into movies values('m3','iron man-2',2001,'english','d2');
insert into movies values('m4','arasu',2007,'kannada','d3');
insert into movies values('m5','iron man-3',2016,'english','d2');
insert into movies values('m6','bahubali-2',2017,'telugu','d4');

insert into movie_cast values('a1','m1','hero');
insert into movie_cast values('a5','m2','hero');
insert into movie_cast values('a1','m3','hero');
insert into movie_cast values('a2','m3','heroine');
insert into movie_cast values('a2','m5','guest');
insert into movie_cast values('a3','m4','hero');
insert into movie_cast values('a4','m4','heroine');
insert into movie_cast values('a1','m5','hero');
insert into movie_cast values('a5','m6','hero');
insert into movie_cast values('a6','m6','heroine');

insert into rating values('m1',8);
insert into rating values('m2',4);
insert into rating values('m3',6);
insert into rating values('m4',8);
insert into rating values('m5',7);
insert into rating values('m6',9);
insert into rating values('m2',9);
insert into rating values('m1',4);

select * from actor;
select * from director;
select * from movies;
select * from movie_cast;
select * from rating;

--Query1
select mov_title
from movies
where dir_id in (select dir_id from director where dir_name = 'hitchcock');

--Query2
select mov_title
from movies m, movie_cast mc
where m.mov_id=mc.mov_id
and mc.act_id in ( select act_id from movie_cast
group by act_id having count (act_id)>1)
group by mov_title;

--Query2 alternate
select mov_title, a.act_name
from movies m, movie_cast mc, actor a
where m.mov_id = mc.mov_id
and mc.act_id = a.act_id
and mc.act_id in (select act_id from movie_cast
group by act_id having count (*) > 1);

--Query3
select act_name, mov_title, mov_year
from actor a
join movie_cast c
on a.act_id = c.act_id
join movies m
on c.mov_id = m.mov_id
where m.mov_year not between 2000 and 2015;

--Query4
select mov_title, max(rev_stars)
from movies 
inner join rating using (mov_id)
group by mov_title having max(rev_stars)>0
order by mov_title;

--Query4 alternate
select mov_title , max(rev_stars) as best_rating
from movies m, rating r
where m.mov_id = r.mov_id
and r.rev_stars is not null
group by mov_title
order by mov_title;

--Query5
update rating set rev_stars = 5
where mov_id in (select mov_id from movies where dir_id in (select dir_id from director where dir_name = 'steven spielberg'));
select * from rating;@




