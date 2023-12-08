select * from user_tab_comments;
SELECT 'DROP TABLE "' || TABLE_NAME || '" CASCADE CONSTRAINTS;' FROM user_tables;

-- 이미지 1
create table img(
                    img_seq Number primary key,
                    img_name VARCHAR2(100) NOT NULL,
                    img_origin_name VARCHAR2(100) NOT NULL,
                    img_size Number NOT NULL,
                    img_type VARCHAR2(10) NOT NULL,
                    representative VARCHAR2(5) CHECK(representative IN('false','true'))
);




-- 위치 2
create table path(
                     path_seq Number PRIMARY KEY,
                     location_x Number NOT NULL,
                     location_y Number NOT NULL,
                     location_z Number NOT NULL
);



-- 유저 3
create table userinfo(
                         user_seq NUMBER PRIMARY KEY,
                         user_id VARCHAR2(15) NOT NULL,
                         user_pwd VARCHAR2(100) NOT NULL,
                         user_name VARCHAR2(20) NOT NULL,
                         user_rrn VARCHAR2(100) NOT NULL,
                         user_phone VARCHAR2(15) NOT NULL UNIQUE,
                         user_eamil VARCHAR2(30) NOT NULL UNIQUE,
                         user_address VARCHAR2(50),
                         user_role VARCHAR2(10) NOT NULL,
                         img_seq NUMBER
);


-- 문의 4
create table inquiry(
                        inq_seq Number primary key,
                        title VARCHAR2(100) NOT NULL,
                        content VARCHAR2(500) NOT NULL,
                        send_date DATE NOT NULL,
                        img_seq Number,
                        constraint inq_img_seq FOREIGN key(img_seq) references img(img_seq)
);


-- 노래방 5
create table karaoke(
                        karaoke_seq number primary key,
                        karaoke_name VARCHAR2(50) NOT NULL,
                        path_seq NUMBER,
                        user_seq Number,
                        karaoke_intro VARCHAR2(150),
                        karaoke_phone VARCHAR2(20),
                        img_seq NUMBER NOT NULL,
                        admin_approval VARCHAR2(5)CHECK(admin_approval IN('false','true')),
                        constraint karaoke_path_seq FOREIGN KEY(path_seq) references path(path_seq) on delete cascade,
                        constraint karaoke_user_seq FOREIGN KEY(user_seq) references userinfo(user_seq)on delete cascade,
                        constraint karaoke_img_seq FOREIGN key(img_seq) references img(img_seq)
);

-- 즐겨찾기 6
create table favorit(
                        favorit_seq NUMBER PRIMARY KEY,
                        user_seq NUMBER NOT NULL,
                        karaoke_seq NUMBER NOT NULL,
                        alias VARCHAR2(20) NOT NULL,
                        constraint favorit_user_seq foreign key(user_seq) references userinfo(user_seq) on delete cascade,
                        constraint favorit_karaoke_seq foreign key(karaoke_seq) references karaoke(karaoke_seq) on delete cascade
);


--리뷰 7
CREATE TABLE review(
                       review_seq Number PRIMARY KEY,
                       title Varchar2(50) NOT NULL,
                       content VARCHAR2(500) not null,
                       create_date Date NOT NULL,
                       update_date Date NOT NULL,
                       img_seq Number,
                       review_views Number NOT NULL,
                       review_recommends Number NOT NULL,
                       declearation Number NOT NULL,
                       user_seq Number NOT NULL,
                       karaoke_seq Number NOT NULL,
                       CONSTRAINT review_user_seq FOREIGN key(user_seq) REFERENCES userinfo (user_seq) on delete cascade,
                       CONSTRAINT review_karaoke_seq FOREIGN key(karaoke_seq) REFERENCES Karaoke(Karaoke_seq)on delete cascade
);


--댓글 8
create table review_comment(
                               cm_seq Number  PRIMARY KEY,
                               cm_group Number NOT NULL,
                               cm_Num Number NOT NULL,
                               title Varchar2(50) NOT NULL,
                               content Varchar2(150) NOT NULL,
                               create_date Date NOT NULL,
                               update_date Date NOT NULL,
                               review_recommends Number NOT NULL,
                               declearation Number NOT NULL,
                               user_seq Number NOT NULL,
                               review_seq Number NOT NULL,
                               img_seq Number,
                               CONSTRAINT comment_user_seq FOREIGN key(user_seq) REFERENCES userinfo(user_seq) on delete cascade,
                               CONSTRAINT comment_review_seq foreign key(review_seq) REFERENCES review(review_seq) on delete cascade,
                               CONSTRAINT comment_img_seq FOREIGN key(img_seq) REFERENCES img(img_seq)
);




--방정보 9
CREATE TABLE Room(
                     room_seq Number NOT NULL PRIMARY KEY,
                     room_size Number NOT NULL,
                     price_Number Number NOT NULL,
                     Room_num Number NOT NULL,
                     karaoke_seq Number NOT NULL,
                     img_seq Number NOT NULL,
                     CONSTRAINT fk_img_seq FOREIGN key(img_seq) REFERENCES img(img_seq),
                     CONSTRAINT fk_karaoke_seq FOREIGN key(karaoke_seq) REFERENCES karaoke(karaoke_seq) on delete cascade
);



--쪽지함 10
CREATE TABLE Message(
                        msg_seq Number NOT NULL PRIMARY KEY,
                        title Varchar2(50) NOT NULL,
                        msg_content Varchar2(500) NOT NULL,
                        msg_date Date NOT NULL,
                        delete_by_sender varchar2(5) NOT NULL CHECK(delete_by_sender IN('false','true')),
                        delete_by_recever varchar2(5) NOT NULL CHECK(delete_by_recever IN('false','true')),
                        send_User Number NOT NULL,
                        recever_User Number NOT NULL,
                        CONSTRAINT fk_send_User FOREIGN key(send_User) REFERENCES Userinfo (user_seq) on delete cascade,
                        CONSTRAINT fk_recever_User FOREIGN key(recever_User) REFERENCES Userinfo (user_seq) on delete cascade
);




--예약 11
CREATE TABLE reservation(
                            rev_seq Number NOT NULL PRIMARY KEY,
                            rev_time Date NOT NULL,
                            rev_approved Varchar2(5) NOT NULL CHECK(rev_approved IN('false','true')),
                            user_seq Number NOT NULL,
                            room_seq Number NOT NULL,
                            CONSTRAINT reservation_user_seq FOREIGN key(user_seq) REFERENCES userinfo(user_seq) on delete cascade,
                            CONSTRAINT reservation_Room_seq FOREIGN key(room_seq) REFERENCES room(room_Seq) on delete cascade
);
