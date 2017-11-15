package cn.angusyu.mall.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * @author AngusYu
 */
public class Product {
    private Long id;
    private String name;
    private Double price;
    private Integer stock;
    private String imageSrc;
    private String briefIntro;
    private String detailInfo;
    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "GMT+08")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date productionDate;
    @JsonFormat(pattern = "yyyy-MM-dd",timezone = "GMT+08")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date expirationDate;
    private Boolean available;
    private Boolean recommended;
    private Category category;

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

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Integer getStock() {
        return stock;
    }

    public void setStock(Integer stock) {
        this.stock = stock;
    }

    public String getImageSrc() {
        return imageSrc;
    }

    public void setImageSrc(String imageSrc) {
        this.imageSrc = imageSrc;
    }

    public String getBriefIntro() {
        return briefIntro;
    }

    public void setBriefIntro(String briefIntro) {
        this.briefIntro = briefIntro;
    }

    public String getDetailInfo() {
        return detailInfo;
    }

    public void setDetailInfo(String detailInfo) {
        this.detailInfo = detailInfo;
    }

    public Date getProductionDate() {
        return productionDate;
    }

    public void setProductionDate(Date productionDate) {
        this.productionDate = productionDate;
    }

    public Date getExpirationDate() {
        return expirationDate;
    }

    public void setExpirationDate(Date expirationDate) {
        this.expirationDate = expirationDate;
    }

    public Boolean getAvailable() {
        return available;
    }

    public void setAvailable(Boolean available) {
        this.available = available;
    }

    public Boolean getRecommended() {
        return recommended;
    }

    public void setRecommended(Boolean recommended) {
        this.recommended = recommended;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", stock=" + stock +
                ", imageSrc='" + imageSrc + '\'' +
                ", briefIntro='" + briefIntro + '\'' +
                ", detailInfo='" + detailInfo + '\'' +
                ", productionDate=" + productionDate +
                ", expirationDate=" + expirationDate +
                ", available=" + available +
                ", recommended=" + recommended +
                ", category=" + category +
                '}';
    }
}
