import { IsOptional, IsString, MaxLength } from 'class-validator';

export class UpdateCourseDto {
  @IsOptional()
  @IsString()
  @MaxLength(30)
  course_code?: string;

  @IsOptional()
  @IsString()
  @MaxLength(150)
  course_name?: string;

  @IsOptional()
  @IsString()
  description?: string;
}
