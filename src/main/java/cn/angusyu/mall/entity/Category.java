package cn.angusyu.mall.entity;

import com.fasterxml.jackson.annotation.JsonInclude;

/**
 * @author AngusYu
 */
public class Category {
    private Long id;
    private String name;
    private Boolean hot;
    private Integer productAmount;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Boolean getHot() {
        return hot;
    }

    public void setHot(Boolean hot) {
        this.hot = hot;
    }

    public Integer getProductAmount() {
        return productAmount;
    }

    public void setProductAmount(Integer productAmount) {
        this.productAmount = productAmount;
    }

    @Override
    public String toString() {
        return "Category{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", hot=" + hot +
                ", productAmount=" + productAmount +
                '}';
    }
}
