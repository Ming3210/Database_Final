create database room_management;
use room_management;

-- II
-- II.1 . Thiết kế cơ sở dữ liệu

create table Customer(
	customer_id char(10) primary key,
    customer_full_name varchar(150) not null,
    customer_email varchar(255) unique,
    customer_address varchar(255) not null
);

create table Room(
	room_id char(5) primary key,
    room_price decimal check(room_price >0),
    room_status enum('Available','Booked') default ('Available'),
    room_area int
);

create table Booking(
	booking_id int primary key auto_increment,
    customer_id char(10),
    room_id char(5),
    check_in_date date not null,
    check_out_date date not null,
    total_amount decimal,
    foreign key (customer_id) references Customer(customer_id),
    foreign key (room_id) references Room(room_id)
);

create table Payment(
	payment_id int primary key auto_increment,
    booking_id int,
    payment_method varchar(50),
    payment_date date not null,
    payment_amount decimal,
    foreign key(booking_id) references Booking(booking_id)
);


-- II.2 . Thêm cột room_type có kiểu dữ liệu là enum gồm các giá trị "single", "double", "suite" trong bảng Room.

alter table room
add column room_type enum('single','double','suite');


-- II.3 . Thêm cột số điện thoại khách hàng (customer_phone) trong bảng Customer có kiểu dữ liệu char(15), có rằng buộc not null và unique.

alter table Customer
add column customer_phone char(15) not null unique;


-- II.4 . Thêm ràng buộc cho cột total_amount trong bảng Booking phải có giá trị lớn hơn hoặc bằng 0.

alter table Booking
modify total_amount decimal check(total_amount>0);


-- III

-- III.1 . Thêm dữ liệu vào các bảng

insert into customer(customer_id,customer_full_name,customer_email,customer_phone,customer_address)
values 
('C001','Nguyen Anh Tu','tu.nguyen@example.com','0912345678','Hanoi, Vietnam'),
('C002','Tran Thi Mai','mai.tran@example.com','0923456789','Ho Chi Minh, Vietnam'),
('C003','Le Minh Hoang','hoang.le@example.com','0934567890','Danang, Vietnam'),
('C004','Pham Hoang Nam','nam.pham@example.com','0945678901','Hue, Vietnam'),
('C005','Vu Minh Thu','thu.vu@example.com','0956789012','Hai Phong, Vietnam'),
('C006','Nguyen Thi Lan','lan.nguyen@example.com','0967890123','Quang Ninh, Vietnam'),
('C007','Bui Minh Tuan','tuan.bui@example.com','0978901234','Bac Giang, Vietnam'),
('C008','Pham Quang Hieu','hieu.pham@example.com','0989012345','Quang Nam, Vietnam'),
('C009','Le Thi Lan','lan.le@example.com','0990123456','Da Lat, Vietnam'),
('C010','Nguyen Thi Mai','mai.nguyen@example.com','0901234567','Can Tho, Vietnam')
;


insert into room(room_id,room_type,room_price,room_status,room_area)
values
('R001','Single',100.0,'Available',25),
('R002','Double',150.0,'Booked',40),
('R003','Suite',250.0,'Available',60),
('R004','Single',120.0,'Booked',30),
('R005','Double',160.0,'Available',35)
;

insert into booking(customer_id,room_id,check_in_date,check_out_date,total_amount)
values
('C001','R001','2025-03-01','2025-03-05',400.0),
('C002','R002','2025-03-02','2025-03-06',600.0),
('C003','R003','2025-03-03','2025-03-07',1000.0),
('C004','R004','2025-03-04','2025-03-08',480.0),
('C005','R005','2025-03-05','2025-03-09',800.0),
('C006','R001','2025-03-06','2025-03-10',400.0),
('C007','R002','2025-03-07','2025-03-11',600.0),
('C008','R003','2025-03-08','2025-03-12',1000.0),
('C009','R004','2025-03-09','2025-03-13',480.0),
('C010','R005','2025-03-10','2025-03-14',800.0)
;

insert into payment(booking_id,payment_method,payment_date,payment_amount)
values
(1,'Cash','2025-03-05',400.0),
(2,'Credit Card','2025-03-06',600.0),
(3,'Bank Transfer','2025-03-07',1000.0),
(4,'Cash','2025-03-08',480.0),
(5,'Credit Card','2025-03-09',800.0),
(6,'Bank Transfer','2025-03-10',400.0),
(7,'Cash','2025-03-11',600.0),
(8,'Credit Card','2025-03-12',1000.0),
(9,'Bank Transfer','2025-03-13',480.0),
(10,'Cash','2025-03-14',800.0),
(1,'Credit Card','2025-03-15',400.0),
(2,'Bank Transfer','2025-03-16',600.0),
(3,'Cash','2025-03-17',1000.0),
(4,'Credit Card','2025-03-18',480.0),
(5,'Bank Transfer','2025-03-19',800.0),
(6,'Cash','2025-03-20',400.0),
(7,'Credit Card','2025-03-21',600.0),
(8,'Bank Transfer','2025-03-22',1000.0),
(9,'Cash','2025-03-23',480.0),
(10,'Credit Card','2025-03-24',800.0)
;

/* III.2 .  Viết câu update cho phép cập nhật dữ liệu cho các khách hàng trong bảng Booking
Công thức tính tổng tiền (total_amount) = giá phòng * số ngày lưu trú.
Chỉ cập nhật tổng tiền khi trạng thái phòng là "Booked" và ngày nhận phòng (check_in_date) đã qua.*/


update booking b join room r on b.room_id = r.room_id
set b.total_amount = (date(b.check_out_date) - date(b.check_in_date)) * r.room_price
where r.room_status = 'Booked' and curdate() > b.check_in_date;


-- III.3 . Xóa các thanh toán trong bảng Payment nếu phương thức thanh toán là "Cash" và tổng tiền thanh toán (payment_amount) nhỏ hơn 500.

delete 
from payment where payment_method = 'Cash' and payment_amount < 500;


-- IV


-- IV.1 . Lấy thông tin khách hàng gồm mã khách hàng, họ tên, email, số điện thoại và địa chỉ được sắp xếp theo họ tên khách hàng tăng dần.
select customer_id,customer_full_name,customer_email,customer_phone,customer_address
from customer order by customer_full_name asc;


-- IV.2 . Lấy thông tin các phòng khách sạn gồm mã phòng, loại phòng, giá phòng và diện tích phòng, sắp xếp theo giá phòng giảm dần.
select room_id,room_type,room_price,room_area 
from room order by room_price desc;


-- IV.3 . Lấy thông tin khách hàng và phòng khách sạn đã đặt, gồm mã khách hàng, họ tên khách hàng, mã phòng, ngày nhận phòng và ngày trả phòng.
select c.customer_id, c.customer_full_name, b.room_id, b.check_in_date, b.check_out_date
from booking b join customer c on b.customer_id = c.customer_id;


/* IV.4 . Lấy danh sách khách hàng và tổng tiền đã thanh toán khi đặt phòng,
 gồm mã khách hàng, họ tên khách hàng, phương thức thanh toán và số tiền thanh toán, sắp xếp theo số tiền thanh toán giảm dần. */
select c.customer_id, c.customer_full_name, p.payment_method, b.total_amount
from payment p join booking b on p.booking_id = b.booking_id
join customer c on c.customer_id = b.customer_id
order by b.total_amount desc;

-- IV.5 . Lấy thông tin khách hàng từ vị trí thứ 2 đến thứ 4 trong bảng Customer được sắp xếp theo tên khách hàng.
select customer_id,customer_full_name,customer_email,customer_phone,customer_address
from customer order by customer_full_name limit 3 offset 2; 


/* IV.6 . Lấy danh sách khách hàng đã đặt ít nhất 2 phòng và có tổng số tiền thanh toán trên 1000,
 gồm mã khách hàng, họ tên khách hàng và số lượng phòng đã đặt. */
select c.customer_id, c.customer_full_name, count(c.customer_id) as total_booking
from customer c join booking b on c.customer_id = b.customer_id
group by b.customer_id
having total_booking >=2 and sum(b.total_amount)>1000;

/* IV.7 . Lấy danh sách các phòng có tổng số tiền thanh toán dưới 1000 và có ít nhất 3 khách hàng đặt,
 gồm mã phòng, loại phòng, giá phòng và tổng số tiền thanh toán. */
select r.room_id, r.room_type, r.room_price, sum(b.total_amount)
from room r join booking b on r.room_id = b.room_id
join customer c on c.customer_id = b.customer_id
group by b.room_id
having sum(b.total_amount) < 1000 and count(b.room_id) >= 3;


/* IV.8 . Lấy danh sách các khách hàng có tổng số tiền thanh toán lớn hơn 1000,
 gồm mã khách hàng, họ tên khách hàng, mã phòng, tổng số tiền thanh toán. */

select c.customer_id, c.customer_full_name, r.room_id, sum(b.total_amount), count(b.customer_id)
from customer c join booking b on c.customer_id = b.customer_id
join room r on r.room_id = b.room_id
group by b.customer_id, r.room_id;



-- IV.9 . Lấy danh sách các phòng có số lượng khách hàng đặt nhiều nhất và ít nhất, gồm mã phòng, loại phòng và số lượng khách hàng đã đặt
select r.room_id, r.room_type, count(b.room_id)
from room r join booking b on r.room_id = b.room_id
join customer c on c.customer_id = b.customer_id where r.room_id  in ((select r.room_id
																	from room r join booking b on r.room_id = b.room_id
																	join customer c on c.customer_id = b.customer_id
																	group by b.room_id order by count(b.room_id) desc limit 1),
                                                                    (select r.room_id
																	from room r join booking b on r.room_id = b.room_id
																	join customer c on c.customer_id = b.customer_id
																	group by b.room_id order by count(b.room_id) asc limit 1))
group by b.room_id order by count(b.room_id)
;



/* IV.10 . Lấy danh sách các khách hàng có tổng số tiền thanh toán
 của lần đặt phòng cao hơn số tiền thanh toán trung bình của tất cả các khách hàng cho cùng phòng,
 gồm mã khách hàng, họ tên khách hàng, mã phòng, tổng tiền thanh toán */
 
select c.customer_id, c.customer_full_name, r.room_id, b.total_amount 
from customer c join booking b on c.customer_id = b.customer_id
join room r on r.room_id = b.room_id
where b.total_amount > (select avg(total_amount) from booking);


-- V
/* V.1 . Tạo một view để lấy thông tin các phòng và khách hàng đã đặt, với điều kiện ngày nhận phòng nhỏ hơn ngày 2025-03-10.
 Cần hiển thị các thông tin sau: Mã phòng, Loại phòng, Mã khách hàng, họ tên khách hàng */
create view take_customer_infor as 
select r.room_id, r.room_type, c.customer_id, c.customer_full_name
from customer c join booking b on c.customer_id = b.customer_id
join room r on r.room_id = b.room_id
where b.check_in_date < '2025-03-10';



/* V.2 . Hãy tạo một view để lấy thông tin khách hàng và phòng đã đặt, với điều kiện diện tích phòng lớn hơn 30 m².
 Cần hiển thị các thông tin sau: Mã khách hàng, Họ tên khách hàng, Mã phòng, Diện tích phòng */
create view customer_info as 
select c.customer_id, c.customer_full_name, r.room_id, r.room_area
from customer c join booking b on c.customer_id = b.customer_id
join room r on r.room_id = b.room_id
where r.room_area > 30;


-- VI
/* VI.1 . Hãy tạo một trigger check_insert_booking để kiểm tra dữ liệu mối khi chèn vào bảng Booking.
 Kiểm tra nếu ngày đặt phòng mà sau ngày trả phòng thì thông báo lỗi với nội dung “Ngày đặt phòng không thể sau ngày trả phòng được !” và
 hủy thao tác chèn dữ liệu vào bảng. */

DELIMITER &&
create trigger trg_check_insert_booking before insert on booking
for each row

begin
	if NEW.check_in_date > NEW.check_out_date
		then signal sqlstate '45000' set message_text = 'Ngày đặt phòng không thể sau ngày trả phòng được !';
	end if;

end &&

DELIMITER &&;



/* VI.2 . Hãy tạo một trigger có tên là update_room_status_on_booking 
để tự động cập nhật trạng thái phòng thành "Booked" khi một phòng được đặt 
(khi có bản ghi được INSERT vào bảng Booking).
*/

DELIMITER &&
create trigger trg_update_room_status_on_booking after insert on booking
for each row

begin
	update room
    set room_status = 'Booked' where room_id = NEW.room_id;

end &&

DELIMITER &&;


-- VII
-- VII. 1 . Viết store procedure có tên add_customer để thêm mới một khách hàng với đầy đủ các thông tin cần thiết.

DELIMITER &&
create procedure add_customer(
	id_in char(5),
    name_in varchar(255),
    email_in varchar(255),
    address_in varchar(255),
    phone_in char(15)
)

begin
	insert into customer(customer_id,customer_full_name,customer_email,customer_address,customer_phone)
    values (id_in,name_in,email_in,address_in,phone_in);

end &&;

DELIMITER &&;

call add_customer('C011','Pham Van Hai','haimatnai116@gmail.com','Thanh Hoa, Viet Nam','0987654321');


-- VII.2 . Hãy tạo một Stored Procedure  có tên là add_payment để thực hiện việc thêm một thanh toán mới cho một lần đặt phòng.
DELIMITER &&
create procedure add_payment (
	p_booking_id int,
    p_payment_method varchar(255),
    p_payment_amount varchar(255),
    p_payment_date date
)

begin
	insert into payment(booking_id,payment_method,payment_amount,payment_date)
    values (p_booking_id,p_payment_method,p_payment_amount,p_payment_date);

end &&;

DELIMITER &&;

drop procedure add_payment;
call add_payment(1,'Cash',499.0,'2025-02-28');

