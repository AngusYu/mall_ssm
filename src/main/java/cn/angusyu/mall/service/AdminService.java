package cn.angusyu.mall.service;

import cn.angusyu.mall.dto.PaginationResult;
import cn.angusyu.mall.entity.Admin;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author AngusYu
 */
public interface AdminService {

    Integer insertAdmin(Admin admin);

    Integer deleteAdminByIds(List<Long> ids);

    Integer updateAdmin(Admin admin);

    Admin getAdminByAdminId(Long id);

    Admin getAdminByLoginName(String loginName);

    PaginationResult listAdmins(Integer page, Integer rows, String fuzzyParam);

    Integer login(String loginName,String password);

    Boolean checkAdminLoginName(String name);
}
