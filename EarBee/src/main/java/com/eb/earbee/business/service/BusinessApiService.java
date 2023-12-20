package com.eb.earbee.business.service;


import com.eb.earbee.business.request.BusinessApplyRequest;

import com.eb.earbee.business.response.BusinessApplyResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Service
@PropertySource("classpath:business.properties")


public class BusinessApiService {
    @Value("${business.url}")
    private String urlBusiness;
    @Value("${business.encoding}")
    private String encodingKey;
    @Value("${business.decoding}")
    private String decodingKey;

    // 변수값이 정상적으로 들어오는지 확인하는 메서드
    public List<String> checkValue() {
        return Arrays.asList(urlBusiness, encodingKey, decodingKey);
    }


    // 사업자 번호 조회 메서드
    @Transactional
    public  BusinessApplyResponse businessSerchNum(BusinessApplyRequest dto) {
        StringBuilder str = new StringBuilder(); // url 넣을 stringBuilder
        str.append(urlBusiness);
        str.append(encodingKey);
        StringBuffer sb = new StringBuffer();
        BufferedReader br;
        String result = "";

        try {
            URL url = new URL(str.toString()); // url 생성
            HttpURLConnection con = (HttpURLConnection) url.openConnection(); // api 연결할 객체 생성 이떄 url은 생성한 url
            con.setRequestMethod("POST"); // 전송방식 post
            con.setRequestProperty("Content-Type", "application/json; charset = utf-8"); // request body 전송을 aspplcation/json으로 서버 전달
            con.setDoOutput(true); // outputStream으로 post data를 넘김

            OutputStream os = con.getOutputStream(); // Request body에 넣을 data가 담긴 OutputStream
            os.write(dto.getJsonApply().getBytes(StandardCharsets.UTF_8)); // outStream에 body 삽입 utf-8방식으로
            os.flush();
            os.close();


            if (con.getResponseCode() != 200) { // 응답코드가 200이 아니면 null 반환
                return null;
            } else { // 제공받은 내용을 bufferreade에 저장
                br = new BufferedReader(new InputStreamReader(con.getInputStream(), StandardCharsets.UTF_8));
            }
            result = br.readLine();
            br.close();

            // String -> JSON 변경 후 자바 객체로 변경
            JSONParser jsonParser = new JSONParser();
            JSONObject jsonObject = (JSONObject) jsonParser.parse(result); // 전체 JSON parser
            Object match_cnt = jsonObject.get("match_cnt"); // 매칭된 데이터 수를 Object에 임시 저장

            if (match_cnt != null) {
                String cnt = jsonObject.get("match_cnt").toString(); // null이 아니면 cnt에 매칭된 수 저장

                // JSON data의 배열을 저장
                JSONArray jsonArray = (JSONArray) jsonObject.get("data");
                JSONObject data = (JSONObject) jsonArray.get(0);

                // BusinessResponse에 담아 return
                String b_no = String.valueOf(data.get("b_no"));
                String b_stt_cd = String.valueOf(data.get("b_stt_cd"));

                return new BusinessApplyResponse(Integer.parseInt(b_no),Integer.parseInt(b_stt_cd));


            }
            System.out.println("조회 결과 없음");
            return null;



        } catch (IOException | ParseException e) {
            throw new RuntimeException(e);
        }


    }
}
