-- For Login
alter proc spLoginUser
    @EmailId NVARCHAR(MAX),
    @Password NVARCHAR(MAX)
as
begin
    declare @Message VARCHAR(50);
    declare @StatusCode INT;
    declare @ErrorStatus BIT;

    if  exists (select  * from Users where EmailId = @EmailId AND Password = @Password)
    begin
        set @Message = 'User Login Successful';
        set @StatusCode = 200;
        set @ErrorStatus = 0;
    end
    else
    begin
        set @Message = 'Try to Login again. Check your email and password once.';
        set @StatusCode = 404;
        set @ErrorStatus = 1;
    end

    if @ErrorStatus = 0
    begin
        select @ErrorStatus as error_status, @Message as message, @StatusCode as statusCode;
    end
    else
    begin
        select @ErrorStatus as error_status, @Message as message, @StatusCode as statusCode;
    end
end;

exec  spLoginUser 'someshm186@gmail.com','Somesh@18'

-- output error status=0, message=User Login Successful,statusCode=200;

exec spLoginUser 'soemhtutu','Somrjbrej'

-- error_staus=1 ,message='Try to Login again. Check your email and password ',stausCode=404



create proc updateInsertUser
@UserId int,
@FullName nvarchar(max),
@EmailId nvarchar(max),
@Password nvarchar(max),
@Mobile bigint
as
begin 
	declare @Message varchar(50);
    declare @StatusCode int;
    declare @ErrorStatus bit;

	if exists(select * from Users where UserId=@UserId)
	begin
		update Users set FullName=@FullName ,EmailId=@EmailId,Password=@Password,Mobile=@Mobile where UserId=@UserId
		set @Message = 'User Details Updated Successful';
        set @StatusCode = 200;
        set @ErrorStatus = 0;
	end

	else
	begin
		insert into Users values(@FullName,@EmailId,@Password,@Mobile)
		set @Message = 'User Created  Successful';
        set @StatusCode = 200;
        set @ErrorStatus = 0;
	end

	 if @ErrorStatus = 0
    begin
        select @ErrorStatus as error_status, @Message as message, @StatusCode as statusCode;
    end
    else
    begin
        select @ErrorStatus as error_status, @Message as message, @StatusCode as statusCode;
    end
end;

exec updateInsertUser 5,'Venky','venky@gmail.com','venkey@123',8688442684
 -- error_status =0,message=User Details Updated Successful ,Status Code =200


 create proc sp_deleUser
 @UserId int
 as
 begin

	declare @Message varchar(100);
    declare @StatusCode int;
    declare @ErrorStatus bit;

	if exists(select * from Users where UserId=@UserId)
	begin
		delete from Users  where UserId=UserId
		set @Message = 'Successfully done';
        set @StatusCode = 200;
        set @ErrorStatus = 0;
	end
	else
		begin
			set @Message = 'Process has been Failed';
			set @StatusCode = 200;
			set @ErrorStatus = 1;
		end
	 if @ErrorStatus = 0
    begin
        select @ErrorStatus as error_status, @Message as message, @StatusCode as statusCode;
    end
    else
    begin
        select @ErrorStatus as error_status, @Message as message, @StatusCode as statusCode;
    end
end

exec sp_deleUser 5
 -- error_status =0,message='Successfully done' ,Status Code =201


alter proc getAllUsersSp
as
begin
	declare @Message varchar(100);
    declare @StatusCode int;
    declare @ErrorStatus bit;
	declare @UsersCount int;

	if exists(SELECT 1 FROM Users)
	begin
		set @Message = 'All user Details fetched successfully';
		set @StatusCode = 200;
		set @ErrorStatus = 0;
		set @UsersCount= (select count(*) from Users);
	end
	else
	begin
		set @Message = 'No user details found';
		set @StatusCode = 404;
		set @ErrorStatus = 1;
		set @UsersCount= 0
	end

	if @ErrorStatus = 0
    begin
        select @ErrorStatus as error_status, @Message as message, @StatusCode as statusCode,@UsersCount as usercount
    end
    else
    begin
        select @ErrorStatus as error_status, @Message as message, @StatusCode as statusCode,@UsersCount as usercount
    end
end

exec getAllUsersSp

-- output error_status =0,message=All user Details fetched successfully,usersCount=6


alter proc ResetPassword
@EmailId nvarchar(max),
@Password nvarchar(max)
as
begin
	declare @Message varchar(100);
    declare @StatusCode int;
    declare @ErrorStatus bit;

	if exists(select * from Users where EmailId=@EmailId )
	begin
		update  Users set  Password=@Password where EmailId=@EmailId 

		set @Message = 'Reset Password Successful';
		set @StatusCode = 200;
		set @ErrorStatus = 0;
	end
	else
		begin
			set @Message = 'Reset Password UnSuccessful check EmailId once';
			set @StatusCode = 400;
			set @ErrorStatus = 1;
		end
	if @ErrorStatus = 0
    begin
        select @ErrorStatus as error_status, @Message as message, @StatusCode as statusCode;
    end
    else
    begin
        select @ErrorStatus as error_status, @Message as message, @StatusCode as statusCode;
    end
end

exec ResetPassword 'nandini123@gmail.com','nandini'
--out  error_status=0,message=Reset Password Successful,statusCode=200



