package cn.angusyu.mall.service.impl;

import cn.angusyu.mall.dao.UserDao;
import cn.angusyu.mall.dto.PaginationResult;
import cn.angusyu.mall.entity.Product;
import cn.angusyu.mall.entity.User;
import cn.angusyu.mall.service.UserService;
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
import static cn.angusyu.mall.util.Constant.ZERO_ID;

/**
 * @author AngusYu
 */
@Service
public class UserServiceImpl implements UserService {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private UserDao userDao;

    @Override
    public Integer insertUser(User user) {
        User u = verifyInsertUser(user);
        if (u != null) {
            return userDao.insertUser(user);
        }
        return -1;
    }

    @Override
    public Integer deleteUserByIds(List<Long> ids) {
        List<Long> i = verifyAndFixIds(ids);
        if (i != null) {
            return userDao.updateDeleteByIds(ids);
        }
        return -1;
    }

    @Override
    public Integer updateUser(User user) {
        User u = verifyUpdateUser(user);
        if (u != null) {
            return userDao.updateUser(u);
        }
        return -1;
    }

    @Override
    public User getUserById(Long id) {
        if (id != null && id > ZERO_ID) {
            return userDao.getById(id);
        }
        return null;
    }

    @Override
    public User getUserByLoginName(String loginName) {
        return userDao.getByLoginName(loginName);
    }

    @Override
    public PaginationResult listUsers(Integer page, Integer rows, String fuzzyParam) {
        if (page == null || rows == null) {
            page = 1;
            rows = 15;
        }
        PageInfo pageInfo;
        List<User> users;
        PageHelper.startPage(page, rows);
        if (fuzzyParam == null || "".equals(fuzzyParam)) {
            users = userDao.listAll();
        } else {
            users = userDao.listAllQueryByFuzzyParam(fuzzyParam);
        }
        pageInfo = new PageInfo<>(users);
        return new PaginationResult(pageInfo.getTotal(), users);
    }

    @Override
    public Integer login(String loginName, String password) {
        boolean isLoginNameValid;
        boolean isPasswordValid;
        if (loginName != null && password != null) {
            isLoginNameValid = loginName.matches(LOGIN_NAME_REGEX);
            if (isLoginNameValid) {
                isPasswordValid = password.matches(USERNAME_PASSWORD_REGEX);
                if (isPasswordValid) {
                    User userGetByLoginName = userDao.getByLoginNameCaseSensitive(loginName);
                    if (userGetByLoginName != null) {
                        if (password.equals(userGetByLoginName.getPassword())) {
                            logger.info("login: login success.");
                            return 1;
                        } else {
                            logger.info("login: password is incorrect.");
                            return 0;
                        }
                    } else {
                        logger.info("login: loginName not exist.");
                        return -1;
                    }
                } else {
                    logger.info("login: password is invalid.");
                }
            } else {
                logger.info("login: loginName is invalid.");
            }
        }
        return -2;
    }

    @Override
    public Boolean checkUserLoginName(String loginName) {
        boolean isLoginNameValid = loginName.length() > 0 && loginName.length() <= VARCHAR_MAX_LENGTH_20;
        if (isLoginNameValid) {
            isLoginNameValid = userDao.getByLoginName(loginName) == null;
        }
        return isLoginNameValid;
    }

    private User verifyInsertUser(User user) {
        boolean isLoginNameNotNull;
        boolean isPasswordNotNull;
        boolean isUserNameNotNull;
        if (user != null) {
            isLoginNameNotNull = user.getLoginName() != null && !"".equals(user.getLoginName());
            isPasswordNotNull = user.getPassword() != null && !"".equals(user.getPassword());
            isUserNameNotNull = user.getUserName() != null && !"".equals(user.getUserName());
            boolean isLoginNameValid;
            boolean isLoginNameNotExist;
            boolean isPasswordValid;
            boolean isUserNameValid;
            if (isLoginNameNotNull && isPasswordNotNull && isUserNameNotNull) {
                isLoginNameValid = user.getLoginName().matches(LOGIN_NAME_REGEX);
                if (isLoginNameValid) {
                    isLoginNameNotExist = userDao.getByLoginName(user.getLoginName()) == null;
                    if (isLoginNameNotExist) {
                        isPasswordValid = user.getPassword().matches(USERNAME_PASSWORD_REGEX);
                        if (user.getUserName().length() > VARCHAR_MAX_LENGTH_20) {
                            logger.info("verifyInsertUser: user.userName is too long, cut out to 20.");
                            user.setUserName(user.getUserName().substring(0, VARCHAR_MAX_LENGTH_20));
                        }
                        isUserNameValid = user.getUserName().matches(USERNAME_PASSWORD_REGEX);
                        if (isPasswordValid && isUserNameValid) {
                            logger.info("verifyInsertUser: verify success.");
                            return user;
                        }
                    } else {
                        logger.info("verifyInsertUser: user.loginName already exist.");
                    }
                } else {
                    logger.info("verifyInsertUser: user.loginName is invalid.");
                }
            } else {
                logger.info("verifyInsertUser: user.loginName, user.password or user.userName is empty.");
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
        logger.info("verifyAndFixIds: After filter null, negative, duplicate and ZERO_ID item=" + idSet);
        ids.clear();
        if (idSet.size() > 0) {
            for (Object o : idSet) {
                if (userDao.getById((Long) o) != null) {
                    ids.add((Long) o);
                }
            }
            logger.info("verifyAndFixIds: After filter not exist item=" + ids);
            if (ids.size() > 0) {
                return ids;
            }
        }
        return null;
    }

    private User verifyUpdateUser(User user) {
        boolean isUserIdExist;
        if (user != null) {
            if (user.getId() != null) {
                if (user.getId() > ZERO_ID) {
                    User userGetById = userDao.getById(user.getId());
                    if (userGetById != null) {
                        boolean isUserUseful;
                        //  verify loginName
                        if (user.getLoginName() != null) {
                            boolean isLoginNameValid = user.getLoginName().matches(LOGIN_NAME_REGEX);
                            if (isLoginNameValid) {
                                boolean isLoginNameDuplicated = user.getLoginName().equals(userGetById.getLoginName());
                                if (isLoginNameDuplicated) {
                                    logger.info("verifyUpdateUser: user.loginName is duplicated, set to null.");
                                    user.setLoginName(null);
                                } else {
                                    boolean isLoginNameExist = userDao.getByLoginName(user.getLoginName()) != null;
                                    if (isLoginNameExist) {
                                        logger.info("verifyUpdateUser: user.loginName already exist, verify fail.");
                                        return null;
                                    } else {
                                        logger.info("verifyUpdateUser: user.loginName is valid.");
                                    }
                                }
                            } else {
                                logger.info("verifyUpdateUser: user.loginName is invalid, verify fail.");
                                return null;
                            }
                        }
                        //  password
                        if (user.getPassword() != null) {
                            boolean isPasswordValid = user.getPassword().matches(USERNAME_PASSWORD_REGEX);
                            if (isPasswordValid) {
                                boolean isPasswordDuplicated = user.getPassword().equals(userGetById.getPassword());
                                if (isPasswordDuplicated) {
                                    logger.info("verifyUpdateUser: user.password is duplicated, set to null.");
                                    user.setPassword(null);
                                } else {
                                    logger.info("verifyUpdateUser: user.password is valid.");
                                }
                            } else {
                                logger.info("verifyUpdateUser: user.password is invalid, verify fail.");
                                return null;
                            }
                        }
                        //  userName
                        if (user.getUserName() != null) {
                            boolean isUserNameValid = user.getUserName().matches(USERNAME_PASSWORD_REGEX);
                            if (isUserNameValid) {
                                logger.info("verifyUpdateUser: user.userName is valid.");
                            } else {
                                logger.info("verifyUpdateUser: user.userName is invalid, set to null.");
                                user.setUserName(null);
                            }
                        }
                        //  phone
                        if (user.getPhone() != null) {
                            boolean isPhoneValid = user.getPhone().matches(PHONE_REGEX);
                            if (isPhoneValid) {
                                logger.info("verifyUpdateUser: user.phone is valid");
                            } else {
                                logger.info("verifyUpdateUser: user.phone is invalid, set to null");
                                user.setPhone(null);
                            }
                        }
                        //  email
                        if (user.getEmail() != null) {
                            boolean isEmailValid = user.getEmail().matches(EMAIL_REGEX);
                            if (isEmailValid) {
                                logger.info("verifyUpdateUser: user.email is valid.");
                            } else {
                                logger.info("verifyUpdateUser: user.email is invalid, set to null");
                                user.setEmail(null);
                            }
                        }
                        //  address
                        if (user.getAddress() != null) {
                            if (user.getAddress().length() > VARCHAR_MAX_LENGTH_255) {
                                logger.info("verifyUpdateUser: user.address is too long, cut out to 255.");
                                user.setAddress(user.getAddress().substring(0, VARCHAR_MAX_LENGTH_255));
                            }
                        }

                        isUserUseful = user.getLoginName() != null || user.getPassword() != null
                                || user.getUserName() != null || user.getSex() != null
                                || user.getPhone() != null || user.getEmail() != null
                                || user.getAddress() != null;
                        if (isUserUseful) {
                            return user;
                        }

                    } else {
                        logger.info("verifyUpdateUser: user.id not exist.");
                    }
                } else {
                    logger.info("verifyUpdateUser: user.id is invalid.");
                }
            } else {
                logger.info("verifyUpdateUser: user.id is null.");
            }
        }
        return null;
    }
}
