package com.quizplatform.api.service;

import com.quizplatform.api.dto.BulkUploadDtos.BulkUploadResult;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class BulkUploadService {
    private static final int REQUIRED_COLUMNS = 19;

    public BulkUploadResult validateQuestionCsv(MultipartFile file) {
        var errors = new ArrayList<String>();
        int totalRows = 0;
        int validRows = 0;
        try (var reader = new BufferedReader(new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8))) {
            String line = reader.readLine();
            while ((line = reader.readLine()) != null) {
                totalRows++;
                String[] columns = line.split(",", -1);
                if (columns.length < REQUIRED_COLUMNS) {
                    errors.add("Row " + (totalRows + 1) + ": expected " + REQUIRED_COLUMNS + " columns");
                    continue;
                }
                if (columns[0].isBlank() || columns[2].isBlank() || columns[3].isBlank()
                        || columns[5].isBlank() || columns[6].isBlank() || columns[10].isBlank() || columns[16].isBlank()) {
                    errors.add("Row " + (totalRows + 1) + ": exam_code, topic_name, quiz_name, set_number, option_count, question_text and correct_answer are required");
                    continue;
                }
                if (!columns[6].equals("4") && !columns[6].equals("5")) {
                    errors.add("Row " + (totalRows + 1) + ": option_count must be 4 or 5");
                    continue;
                }
                if (columns[6].equals("5") && columns[15].isBlank()) {
                    errors.add("Row " + (totalRows + 1) + ": option_e is required for 5-option quizzes");
                    continue;
                }
                validRows++;
            }
        } catch (Exception ex) {
            errors.add("Unable to read file: " + ex.getMessage());
        }
        return new BulkUploadResult(totalRows, validRows, errors.size(), errors);
    }
}
