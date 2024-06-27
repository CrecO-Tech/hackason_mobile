import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:mobile/domain/entities/scores.dart';

part 'score_repository.g.dart'; // This will be generated by running the build_runner

// @RestApi(baseUrl: "http://52.195.176.75:8000")
@RestApi(baseUrl: "http://192.168.0.225:8000")
abstract class ScoreRepository {
  factory ScoreRepository(Dio dio, {String baseUrl}) = _ScoreRepository;

  @POST("/question1")
  Future submitString1(@Body() Map<String, dynamic> data);

  @POST("/question2")
  Future submitString2(@Body() Map<String, dynamic> data);

  @POST("/question3")
  Future submitString3(@Body() Map<String, dynamic> data);

  @POST("/question4")
  Future submitString4(@Body() Map<String, dynamic> data);
}
