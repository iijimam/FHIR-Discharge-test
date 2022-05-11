# 退院時サマリのJSONテンプレートの準備

- サンプルファイル

    [test_Patient14543-discharge.json](./test_Patient14543-discharge.json)

    検証実行の手順は以下。（FHIRエンドポイントを作成したネームスペースを準備した後は以下）

    - 1) [Sample.FHIR.Utils](./Sample/FHIR/Utils.cls) をインポート

    - 2) ターミナルで以下実行

        ```
        set in={}.%FromJSON("C:\WorkSpace\FHIR-Discharge\FHIR-Discharge-test\test_Patient14543-discharge.json")
        set st=##class(Sample.FHIR.Utils).Validate(in)
        write $system.Status.GetErrorText(st)
        ```

