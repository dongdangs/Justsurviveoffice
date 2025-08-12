package com.spring.app.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name = "category")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class Category {


    @Id
    @Column(name = "categoryNo", nullable = false)
    private int categoryNo;

    @Column(name = "categoryName", length = 50, nullable = false)
    private String categoryName;

    @Column(name = "categoryDescribe", length = 200)
    private String categoryDescribe;

    @Column(name = "categoryImagePath", length = 255)
    private String categoryImagePath;
}
