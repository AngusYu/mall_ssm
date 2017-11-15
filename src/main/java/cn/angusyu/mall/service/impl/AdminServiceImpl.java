package cn.angusyu.mall.service.impl;

import cn.angusyu.mall.dao.AdminDao;
import cn.angusyu.mall.dto.PaginationResult;
import cn.angusyu.mall.entity.Admin;
import cn.angusyu.mall.entity.User;
import cn.angusyu.mall.service.AdminService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static cn.angusyu.mall.util.Constant.*;

/**
 * @author AngusYu
 */
@Service
public class AdminServiceImpl implements AdminService {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private AdminDao adminDao;

    public AdminServiceImpl() {
        super();
    }

    @Override
    public Integer insertAdmin(Admin admin) {
        Admin a = verifyInsertAdmin(admin);
        if (a != null) {
            return adminDao.insertAdmin(a);
        }
        return -1;
    }

    @Override
    public Integer deleteAdminByIds(List<Long> ids) {
        List<Long> i = verifyAndFixIds(ids);
        if (i != null) {
            return adminDao.updateDeleteByIds(i);
        }
        return -1;
    }

    @Override
    public Integer updateAdmin(Admin admin) {
        Admin a = verifyUpdateAdmin(admin);
        if (a != null) {
            return adminDao.updateAdmin(a);
        }
        return -1;
    }

    @Override
    public Admin getAdminByAdminId(Long id) {
        if (id != null && id > ZERO_ID) {
            return adminDao.getById(id);
        }
        return null;
    }

    @Override
    public Admin getAdminByLoginName(String loginName) {
        if (loginName != null && loginName.length() > 0 && loginName.length() <= VARCHAR_MAX_LENGTH_20) {
            return adminDao.getByLoginName(loginName);
        }
        return null;
    }

    @Override
    public PaginationResult listAdmins(Integer page, Integer rows, String fuzzyParam) {
        if (page == null || rows == null) {
            page = 1;
            rows = 15;
        }
        PageInfo pageInfo;
        List<Admin> admins;
        PageHelper.startPage(page, rows);
        if (fuzzyParam == null || "".equals(fuzzyParam)) {
            admins = adminDao.listAll();
        } else {
            admins = adminDao.listAllQueryByFuzzyParam(fuzzyParam);
        }
        pageInfo = new PageInfo<>(admins);
        return new PaginationResult(pageInfo.getTotal(), admins);
    }

    @Override
    public Integer login(String loginName, String password) {
        boolean isLoginNameAndPasswordValid;
        if (loginName != null && password != null) {
            isLoginNameAndPasswordValid = loginName.matches(LOGIN_NAME_REGEX) && password.matches(USERNAME_PASSWORD_REGEX);
            if (isLoginNameAndPasswordValid) {
                Admin admin = adminDao.getByLoginNameCaseSensitive(loginName);
                if (admin != null) {
                    if (password.equals(admin.getPassword())) {
                        logger.info("login: Admin[" + loginName + "] login success.");
                        return 1;
                    } else {
                        logger.info("login: Wrong password.");
                        return 0;
                    }
                } else {
                    logger.info("login: admin not exist.");
                    return -1;
                }
            } else {
                logger.info("login: Invalid loginName or password.");
            }
        }
        return -2;
    }

    @Override
    public Boolean checkAdminLoginName(String loginName) {
        boolean isLoginNameValid = loginName.length() > 0 && loginName.length() <= VARCHAR_MAX_LENGTH_20;
        if (isLoginNameValid) {
            isLoginNameValid = adminDao.getByLoginName(loginName) == null;
        }
        return isLoginNameValid;
    }

    private Admin verifyInsertAdmin(Admin admin) {
        boolean isLoginNameNotNull;
        boolean isPasswordNotNull;
        if (admin != null) {
            isLoginNameNotNull = admin.getLoginName() != null && !"".equals(admin.getLoginName());
            isPasswordNotNull = admin.getPassword() != null && !"".equals(admin.getPassword());
            boolean isLoginNameValid;
            boolean isLoginNameNotExist;
            boolean isPasswordValid;
            if (isLoginNameNotNull && isPasswordNotNull) {
                isLoginNameValid = admin.getLoginName().matches(LOGIN_NAME_REGEX);
                logger.info("verifyInsertAdmin: isLoginNameValid=" + isLoginNameValid);
                if (isLoginNameValid) {
                    //  admin.loginName can't be duplicate
                    isLoginNameNotExist = adminDao.getByLoginName(admin.getLoginName()) == null;
                    isPasswordValid = admin.getPassword().matches(USERNAME_PASSWORD_REGEX);
                    if (isLoginNameNotExist && isPasswordValid) {
                        return admin;
                    }
                }
            }
        }
        return null;
    }

    private List<Long> verifyAndFixIds(List<Long> ids) {
        Set idSet;
        ids.removeAll(Collections.singleton(null));
        //  set negative value to ZERO_ID
        for (int i = 0; i < ids.size(); i++) {
            if (ids.get(i) < ZERO_ID) {
                ids.set(i, ZERO_ID);
            }
        }
        //  remove duplicate value
        idSet = new HashSet(ids);
        //  remove ZERO_ID
        idSet.remove(ZERO_ID);
        logger.info("verifyAndFixIds: After filter null, negative, duplicate and ZERO_ID item=" + idSet.toString());
        ids.clear();
        if (idSet.size() > 0) {
            for (Object o : idSet) {
                if (adminDao.getById((Long) o) != null) {
                    ids.add((Long) o);
                }
            }
            logger.info("verifyAndFixIds: After filter non exist item=" + ids);
            if (ids.size() > 0) {
                return ids;
            }
        }
        return null;
    }

    private Admin verifyUpdateAdmin(Admin admin) {
        boolean isAdminUseful;
        if (admin != null && admin.getId() != null) {
            Admin adminGetById = adminDao.getById(admin.getId());
            if (adminGetById != null) {
                boolean isLoginNameValid;
                boolean isLoginNameExist;
                boolean isPasswordValid;
                if (admin.getLoginName() != null) {
                    isLoginNameValid = admin.getLoginName().matches(LOGIN_NAME_REGEX);
                    boolean isLoginNameUseless;
                    if (isLoginNameValid) {
                        isLoginNameUseless = admin.getLoginName().equals(adminGetById.getLoginName());
                        if (isLoginNameUseless) {
                            //  admin.loginName is meaningless
                            logger.info("verifyUpdateAdmin: admin.loginName is meaningless, set to null.");
                            admin.setLoginName(null);
                        } else {
                            isLoginNameExist = adminDao.getByLoginName(admin.getLoginName()) != null;
                            if (isLoginNameExist) {
                                logger.info("verifyUpdateAdmin: admin.loginName already exist, set to null.");
                                admin.setLoginName(null);
                            }
                        }
                    } else {
                        logger.info("verifyUpdateAdmin: admin.loginName is invalid, set to null.");
                        admin.setLoginName(null);
                    }
                }

                if (admin.getPassword() != null) {
                    isPasswordValid = admin.getPassword().matches(USERNAME_PASSWORD_REGEX);
                    if (!isPasswordValid) {
                        logger.info("verifyUpdateAdmin: admin.password is invalid, set to null.");
                        admin.setPassword(null);
                    }
                }

                isAdminUseful = admin.getLoginName() != null || admin.getPassword() != null;
                logger.info("verifyUpdateAdmin: isAdminUseful=" + isAdminUseful);
                if (isAdminUseful) {
                    return admin;
                } else {
                    logger.info("verifyUpdateAdmin: admin is useless.");
                }

            } else {
                logger.info("verifyUpdateAdmin: admin.id not exist.");
            }
        } else {
            logger.info("verifyUpdateAdmin: admin.id is null.");
        }
        return null;
    }
}
