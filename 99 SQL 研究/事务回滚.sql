
--开始一个事务处理
Begin Tran T1
--执行插入操作
insert into TEST1 ([T1],[T2]) values('20100021','01');
insert into TEST1 ([T1],[T2]) values('20100021','02');
insert into TEST1 ([T1],[T2]) values('20100021','03');
--判断同一学号的选课数量是否符合
IF(select count([T1]) as cnt from [TEST1] where [T1]='20100021')>5
BEGIN
--不符合，回滚事务
rollback Tran T1
END
ELSE
BEGIN
--符合，提交事务
commit Tran T1
END



select*from TEST1