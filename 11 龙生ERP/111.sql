SELECT cpdj.wlno, cpdj.name, cpdj.spec, material.name, material.spec, convert(varchar(20), convert(NUMERIC(10, 2), cpdj.dj))  FROM [dbo].[cpdj]
left join [lserp-LY]..material as material on material.wlno = cpdj.wlno
