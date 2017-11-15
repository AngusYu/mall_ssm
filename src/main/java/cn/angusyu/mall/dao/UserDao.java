package cn.angusyu.mall.dao;

import cn.angusyu.mall.entity.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @author AngusYu
 */
public interface UserDao {

    Integer insertUser(@Param("user") User user);

    Integer updateDeleteByIds(List<Long> ids);

    Integer updateUser(@Param("user") User user);

    User getById(Long id);

    User getByLoginName(String loginName);

    User getByLoginNameCaseSensitive(String loginName);

    List<User> listAll();

    List<User> listAllQueryByFuzzyParam(@Param("fuzzyParam") String fuzzyParam);
}
