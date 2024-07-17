package com.eb.earbee.business.controller;import com.eb.earbee.business.dto.BusinessForm;import com.eb.earbee.business.entity.Business;import com.eb.earbee.business.service.BusinessService;import com.eb.earbee.security.oauth.PrincipalUserDetails;import lombok.extern.slf4j.Slf4j;import org.springframework.data.domain.Pageable;import org.springframework.data.web.PageableDefault;import org.springframework.security.core.annotation.AuthenticationPrincipal;import org.springframework.stereotype.Controller;import org.springframework.ui.Model;import org.springframework.web.bind.annotation.GetMapping;import org.springframework.web.bind.annotation.PostMapping;import org.springframework.web.bind.annotation.RequestMapping;import java.util.List;@Controller@RequestMapping("/earbee")@Slf4jpublic class BusinessController {    private final BusinessService businessService;    public BusinessController(BusinessService businessService) {        this.businessService = businessService;    }    // 업체 등록 게시판    @GetMapping("")    public String businessCollection(Model m,  @PageableDefault(size = 10, page = 0) Pageable pageable){        List<Business> businessList = businessService.findAll(pageable);        m.addAttribute("businessList",businessList);        return "business/main";    }    // 업체 등록 작성 페이지    @GetMapping("/applyplace")    public String applyPlace(){        return "business/apply";    }    @PostMapping("/business/add")    public String add(@AuthenticationPrincipal PrincipalUserDetails user, BusinessForm businessForm){        Business business = businessService.addBusiness(businessForm,user.getUser());        return "redirect:/earbee";    }}