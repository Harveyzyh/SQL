
declare @yymm  varchar(6),@lastyymm  varchar(6) 

set @yymm='202103'


  set @lastyymm= convert(varchar(6), dateadd(month,-1,cast(@yymm+'01' as smalldatetime)),112)


--1、上月期初人数
select count(*) 上月期初人数
from   vps_empinfo   
where convert(varchar(6),entrydate,112)<= @lastyymm   and  deptid1='001'    and (isactive=1 or isactive=0 and  convert(varchar(6),dimissiondate,112)> @lastyymm)

--2、当月期未人数
select count(*) 当月期初人数
from   vps_empinfo   
where convert(varchar(6),entrydate,112)<= @yymm   and  deptid1='001'    and (isactive=1 or isactive=0 and  convert(varchar(6),dimissiondate,112)> @yymm)

--3、当月入职人数
select count(*) 当月入职人数
from   vps_empinfo   
where convert(varchar(6),entrydate,112)= @yymm   and  deptid1='001' 

--4、当月应转正人数  
/* 当月离职在本月转正的计算吗？*/
select count(*) 当月应转正人数
from   vps_empinfo   
where convert(varchar(6),trydate,112)= @yymm  and  empnature<>'正式员工' and  deptid1='001'  and (isactive=1 or isactive=0 and  convert(varchar(6),dimissiondate,112)> @yymm)
  and isnull(empnature,'') not like '%派遣%'  and isnull(empnature,'') not like '%外包%' 

--5、当月实转正人数
select count(*)  实转正人数
from   vps_empinfo   
where convert(varchar(6),confirmdate,112)= @yymm  and  empnature='正式员工' and  deptid1='001'  and (isactive=1 or isactive=0 and  convert(varchar(6),dimissiondate,112)> @yymm)
--6、当月晋升人数
select count(*) from   vps_empinfo   
where  deptid1='001' and  empid in  
(select  empid from  vps_empchangeinfo   where  iseffect='1'   and  cptype='晋升'   and ischeck='1' and  convert(varchar(6),effectdate,112)= @yymm) 

--7、当月离职人数
select count(*) 离职人数
from   vps_empinfo   
where convert(varchar(6),dimissiondate,112)= @yymm   and  deptid1='001' 

--8、当月自愿性离职人数
select count(*) 自愿性离职数
from   vps_empinfo   
where convert(varchar(6),dimissiondate,112)= @yymm   and  deptid1='001' and dimissiontype='自愿性离职'  

--9、当月非自愿性离职人数
select count(*) 非自愿性离职数
from   vps_empinfo   
where convert(varchar(6),dimissiondate,112)= @yymm   and  deptid1='001' and dimissiontype='非自愿性离职' 

--10、当月试用员工离职人数 
/* 当月试用员工离职人数  疑问：只是试用期员工，其他派遣临时工、外包都不算计进去吗？*/
select count(*) 试用员工离职数
from   vps_empinfo   
where convert(varchar(6),dimissiondate,112)= @yymm   and  deptid1='001'  and  empnature='试用员工'

--11、当月转正员工离职人数
select count(*) 转正员工离职数
from   vps_empinfo   
where convert(varchar(6),dimissiondate,112)=@yymm  and   convert(varchar(6),confirmdate,112)= @yymm
		and  deptid1='001'    and  empnature='正式员工'  and   isactive=0
--12当月应续合同人数

 select count(*)
            from vps_contract  
           where isactive=1
		   and deptid1='001'
            and ((@yymm=convert(nvarchar(6),ed1,112)	and bd2 is null and bd3 is null	and bd4 is null and bd5 is null and bd6 is null and isnoend1=0) or 
                                (@yymm=convert(nvarchar(6),ed2,112)	and bd3 is null and bd4 is null	and bd5 is null and bd6 is null and isnoend2=0) or 
                                 (@yymm=convert(nvarchar(6),ed3,112)	and bd4 is null and bd5 is null	and bd6 is null and isnoend3=0) or 
                                 (@yymm=convert(nvarchar(6),ed4,112)	and bd5 is null and bd6 is null	and isnoend4=0) or 
                                 (@yymm=convert(nvarchar(6),ed5,112)	and bd6 is null and isnoend5=0) or (@yymm=convert(nvarchar(6),ed6,112)) and isnoend6=0)

--13、当月实续合同人数
/*这个需要你们帮忙写一下*/


		
/*
declare @yymm  varchar(6),@lastyymm  varchar(6) 

set @yymm='202102'