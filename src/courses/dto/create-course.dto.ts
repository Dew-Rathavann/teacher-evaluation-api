import { IsOptional, IsString, MaxLength } from 'class-validator';

export class CreateCourseDto {
  @IsString()
  @MaxLength(30)
  course_code!: string;

  @IsString()
  @MaxLength(150)
  course_name!: string;

  @IsOptional()
  @IsString()
  description?: string;
}
