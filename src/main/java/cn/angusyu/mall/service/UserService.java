package cn.angusyu.mall.service;

import cn.angusyu.mall.dto.PaginationResult;
import cn.angusyu.mall.entity.User;

import java.util.List;

public interface UserService {

    Integer insertUser(User user);

    Integer deleteUserByIds(List<Long> ids);

    Integer updateUser(User user);

    User getUserById(Long id);

    User getUserByLoginName(String loginName);

    PaginationResult listUsers(Integer page, Integer rows, String fuzzyParam);

    Integer login(String loginName, String password);

    Boolean checkUserLoginName(String loginName);
}
