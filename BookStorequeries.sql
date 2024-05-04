create table UserAddress(
Id int identity(1,1) primary key,
FullAddress nvarchar(max),
City nvarchar(max),
State nvarchar(max),
Type varchar(50),
UserId bigint Foreign key references Users(UserId))

select * from UserAddress;
drop proc spAddAddress
exec spAddAddress 1,'H.No 8-96-B RammaPeta Gudikal','Kadapa','Andhra pradesh','Home'
CREATE PROCEDURE spAddAddress
    @UserId BIGINT,
    @FullAddress NVARCHAR(MAX),
    @City NVARCHAR(MAX),
    @State NVARCHAR(MAX),
    @Type VARCHAR(50)
AS
BEGIN
    INSERT INTO UserAddress (FullAddress, City, State, UserId, Type)
    VALUES (@FullAddress, @City, @State, @UserId, @Type);
END;

create proc spGetAddress
@UserId bigint
as
begin
select * from UserAddress where UserId=@UserId
end;

alter proc spUpdateAddress
@UserId bigint,
@AdId bigint,
@FullAddress nvarchar(max),
@City nvarchar(max),
@State nvarchar(max),
@Type varchar(50)
as
begin
update UserAddress set FullAddress=@FullAddress,City=@City,State=@State,Type=@Type where UserId=@UserId and Id=@AdId
end;


create table Review(Id bigint identity(1,1) primary key,
Review varchar(max) not null,Starts int,
BookId int Foreign Key references Book(BookId),
UserId bigint Foreign Key references Users(UserId))


select * from Review;
alter proc spAddReview
@UserId bigint,
@BookId int,
@Review varchar(max),
@Stars int
as
begin
insert into Review(Review,Stars,BookId,UserId) values(@Review,@Stars,@BookId,@UserId)
end

EXEC sp_rename 'Review.Starts', 'Stars', 'COLUMN';  -- for changing column name

drop proc spAddReview

create procedure spAddReview
@UserId bigint,
@BookId int,
@Review varchar(max),
@Stars int
as
begin
    -- Check if Stars is within valid range
    if @Stars between 1 and 5
    begin
        -- Insert the review into the Review table
        insert into Review(Review,Stars,BookId,UserId) values(@Review,@Stars,@BookId,@UserId)
        select 'Review added successfully.' as Status
    end
    else
    begin
        -- Stars value is outside the valid range, raise an error or handle accordingly
        select 'Stars value should be between 1 and 5.' as Error
    end
end

exec spAddReview 1,1,'Nice BOOk to Read',10


-- insert BOOk
insert into Book(Title, Price, Author, Description, Quantity, Image) values(
	'Dont make me thibk| Picture Books for Kids |Age 7-11 years', 1500, 'Steve Krug', 'A new, hilarious book from author Steve Krug, creator of the highly-acclaimed The Accidental Prime Minister. Funny by Name. Funny by Nature.', 40, 'https://m.media-amazon.com/images/I/71dyKlIdVTL._SY466_.jpg'
)

select * from Book;
select * from Users;
select * from Review;
--for getting all reviews on a book
create proc GetReviewsForBook
@Id int
as
begin
if not exists (select 1 from Book where BookId = @Id)
    begin
        print 'Invalid BookId.'
        return;
    end

    -- Check if there are any reviews available for the given book
    if not exists (select 1 from Review where BookId = @Id)
    begin
        print 'No reviews available for the given book.'
        return;
    end
select r.Review,r.Stars,u.FullName
from Users u inner join Review r on u.UserId=r.UserId
where r.BookId=@Id
end;

create table Orders(
OrderId int primary key identity(1,1),
Quantity int not null,
BookId int foreign key references Book(BookId),
UserId bigint foreign key references Users(UserId)
)

select * from Orders;
select * from Book;
select * from Users;

insert into Orders values(20,1,2)

alter proc spGetOrders
@UserId int
as
begin
select b.BookId,b.Title,b.Price,b.Author,b.Description,O.Quantity,b.Image
from Orders O inner join Book B on O.BookId=B.BookId where O.UserId=@UserId
end;

alter proc spAddOrder
@UserId int,
@BookId int,
@Quantity int
as
begin
	if @Quantity<=0
	begin
		print 'Error: Quantity must be greater than 0.'
		return
	end
insert into Orders values(@Quantity,@BookId,@UserId)
end;


--wishList
alter table WishList(
UserId bigint foreign key references Users(UserId),
BookId int foreign key references Book(BookId)
)

insert into WishList values(1,1)

alter proc spAddtowhishlist
@UserId int,
@BookId int
as
begin
	if @UserId is null or @BookId is null
		begin
			print 'Error:BookId or UserdId not be null'
			return
		end
insert into WishList values(@UserId,@BookId)
end;

alter proc spGetWhishlist
@UserId int
as
begin
	if @UserId is null
    begin
        print 'Error: UserId cannot be NULL.';
        return; 
    end

    -- Check if the UserId exists in the Users table (assuming there's a Users table)
    if not exists (select 1 from Users where UserId = @UserId)
    begin
        print 'Error: UserId does not exist.';
        return; -- Exit the procedure
    end
select b.BookId,b.Title,b.Author,b.Description,b.Image,b.Price
from Book b inner join WishList w on b.BookId=w.BookId where w.UserId=@UserId
end;

alter proc spDeleteWhishlist
@UserId int,
@BookId int
as
begin
	if @UserId is null or @BookId is null
		begin
			print 'Error:BookId or UserdId not be null'
			return
		end
delete from WishList where UserId=@UserId and BookId=@BookId
end

select * From Book;
create table CartList(
Id int primary key not null identity(1,1),
Quantity int not null,
UserId bigint foreign key references Users(UserId),
BookId int foreign key references Book(BookId)
)

insert into CartList values(30,1,1)

alter proc spGet_cart
@UserId int
as
begin
	if @UserId is null
    begin
        print 'Error: UserId cannot be NULL.';
        return; 
    end

    -- Check if the UserId exists in the Users table (assuming there's a Users table)
    if not exists (select 1 from Users where UserId = @UserId)
    begin
        print 'Error: UserId does not exist.';
        return; -- Exit the procedure
    end
	
select  b.BookId,b.Title,b.Author,b.Description,b.Image,b.Price ,c.Quantity from
CartList c inner join Book b on b.BookId=c.BookId where c.UserId=@UserId
end

select * from CartList;
alter proc spAddToCart
@UserId int,
@BookId int,
@Quantity int
as
begin
	if @UserId is null or @BookId is null
		begin
			print 'Error:BookId or UserdId not be null'
			return
		end
	if @Quantity<=0
	begin
		print 'Error: Quantity must be greater than 0.'
		return
	end
insert into CartList values(@Quantity,@UserId,@BookId)
end


create proc spDelete_cart
@UserId int,
@BookId int
as
begin
	if @UserId is null or @BookId is null
		begin
			print 'Error:BookId or UserdId not be null'
			return
		end
delete from CartList where UserId=@UserId and BookId=@BookId
end

alter proc spUpdateQuantity
@Userid int,
@BookId int,
@Quantity int
as
begin
	if @UserId is null or @BookId is null
		begin
			print 'Error:BookId or UserdId not be null'
			return
		end
	if @Quantity<=0
	begin
		print 'Error: Quantity must be greater than 0.'
		return
	end
update CartList set Quantity=@Quantity where UserId=@UserId and BookId=@BookId
end

select * from Users;
select * from Book;
select * from Orders;

create proc updateinsert
@UserId int,
@FullName nvarchar(max),
@EmailId nvarchar(max),
@Password nvarchar(max),
@Mobile bigint
as
begin
	if exists(select * from Users where UserId=@UserId)
		begin
		 update Users set FullName=@FullName,EmailId=@EmailId,Password=@Password,Mobile=@Mobile where UserId=@UserId
		end
	else
		begin
			insert into Users values(@FullName,@EmailId,@Password,@Mobile)
		end
end



create proc spGetBookByTitleAndAuthor
@Title nvarchar,
@Author nvarchar
as
begin
select * from Book where Title=@Title and Author=@Author
end;

insert into Book(Title, Price, Author, Description, Quantity, Image) values
	('Think Like a Monk', 499,'Jay Shetty','Train Your Mind for Peace and Purpose Every Day', 5, 'https://m.media-amazon.com/images/I/71GBwRkvchL.AC_UF1000,1000_QL80.jpg'),
	('IT TAKES WILL', 399,'will Smith','Life Story of will Smith', 10, 'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1624126289l/58375739.jpg'),
	('Mahabharat', 459,'Vaysa','The Longest Epic Saga', 18, 'https://i.pinimg.com/originals/0c/80/85/0c8085d73d74984f936dab924b1cfc4b.jpg'),
	('Verity', 199,'John krisham','Make the structure of Life', 9, 'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1634158558i/59344312.jpg'),
	('Rich Dad Poor Dad', 299,'Robert T Kiysosaki','How to invest asserts', 7, 'https://m.media-amazon.com/images/I/51u8ZRDCVoL.jpg'); 

	insert into Book(Title, Price, Author, Description, Quantity, Image) values
	('IGNITED MINDS', 499,'A.P.J Abdul Kalam',' Unleashing the Power Within India by A.P.J. Abdul Kalam is a book that encourages readers to believe in India s potential and contribute to its development.', 10, 'https://m.media-amazon.com/images/I/81y66NkOkpL._SY466_.jpg')

	select * from  Wishlist;