# mall_ssm
##后台管理系统<br>
###后端<br>
框架: SSM(Spring, SpringMVC, MyBatis)<br>
数据库: MySQL 5.6<br>
数据库连接池: druid<br>
MyBatis分页插件: PageHelper<br>
日志: logback<br>
应用服务器: Tomcat 8.5.23<br>
单元测试: JUnit<br>
###前端<br>
EasyUI-jQuery<br>
###数据<br>
京东超市<br>
通过Jsoup抓取和初步处理网页, 再通过Python批量下载图片和数据的再次处理.<br>
###完成情况<br>
login: 使用Ajax submit, 返回验证情况(-2,-1,0,1), 成功时返回1, HttpSession中存储"admin", 由前端页面JS根据返回值进行跳转或提示.<br>
logout: HttpSession移除"admin"<br>
category, product, user, admin: <br>
...增: 字段前端验证加后端处理和验证. 前端在新增项时, 对关键字段通过Ajax确认字段的合法性. 后端在业务层对内容合法性进行再次检查处理和验证.<br>
...删: 默认支持多个删除, 前端使用Ajax上传删除项id的list, 在后端业务层对list进行处理, 过滤掉非法项, 空值, 数据库中不存在的项, 再执行删除操作.<br>
...改: 字段前端验证加后端处理和验证. 前端在修改项时, 对关键字段通过Ajax确认字段的合法性. 后端在业务层先确认修改项的id是否合法, 在对内容合法性进行再次检查处理和验证.<br>
...查: 前端上传模糊字, 后端使用MySQL的模糊查询, 在DAO层预先定义好可以模糊查询的字段.<br>
###截图<br>
login:![image](https://raw.githubusercontent.com/AngusYu/mall_ssm/master/capture/backend/login.png)
index:![image](https://raw.githubusercontent.com/AngusYu/mall_ssm/master/capture/backend/index.png)
category:![image](https://raw.githubusercontent.com/AngusYu/mall_ssm/master/capture/backend/category.png)
product:![image](https://raw.githubusercontent.com/AngusYu/mall_ssm/master/capture/backend/product.png)
product/edit:![image](https://raw.githubusercontent.com/AngusYu/mall_ssm/master/capture/backend/product_edit.png)
user:![image](https://raw.githubusercontent.com/AngusYu/mall_ssm/master/capture/backend/user.png)
user/edit:![image](https://raw.githubusercontent.com/AngusYu/mall_ssm/master/capture/backend/user_edit.png)
admin:![image](https://raw.githubusercontent.com/AngusYu/mall_ssm/master/capture/backend/admin_edit.png)
