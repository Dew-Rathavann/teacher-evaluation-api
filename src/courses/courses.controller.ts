import { Body, Controller, Delete, Get, HttpCode, Param, Post, Put } from '@nestjs/common';
import { ApiOperation, ApiParam, ApiResponse, ApiTags } from '@nestjs/swagger';
import { CoursesService } from './courses.service';
import { CreateCourseDto } from './dto/create-course.dto';
import { UpdateCourseDto } from './dto/update-course.dto';
import { ParseBigIntPipe } from '../common/pipes/parse-bigint.pipe';

@ApiTags('courses')
@Controller('courses')
export class CoursesController {
  constructor(private coursesService: CoursesService) {}

  @Get()
  @ApiOperation({ summary: 'List all courses' })
  @ApiResponse({ status: 200, description: 'Array of courses' })
  findAll() {
    return this.coursesService.findAll();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get a course by id' })
  @ApiParam({ name: 'id', type: String, example: '1' })
  @ApiResponse({ status: 200, description: 'The course' })
  @ApiResponse({ status: 404, description: 'Course not found' })
  findOne(@Param('id', ParseBigIntPipe) id: bigint) {
    return this.coursesService.findOne(id);
  }

  @Post()
  @ApiOperation({ summary: 'Create a course' })
  @ApiResponse({ status: 201, description: 'Course created' })
  @ApiResponse({ status: 409, description: 'course_code already exists' })
  create(@Body() dto: CreateCourseDto) {
    return this.coursesService.create(dto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update a course' })
  @ApiParam({ name: 'id', type: String, example: '1' })
  @ApiResponse({ status: 200, description: 'Course updated' })
  @ApiResponse({ status: 404, description: 'Course not found' })
  @ApiResponse({ status: 409, description: 'course_code already exists' })
  update(@Param('id', ParseBigIntPipe) id: bigint, @Body() dto: UpdateCourseDto) {
    return this.coursesService.update(id, dto);
  }

  @Delete(':id')
  @HttpCode(204)
  @ApiOperation({ summary: 'Delete a course' })
  @ApiParam({ name: 'id', type: String, example: '1' })
  @ApiResponse({ status: 204, description: 'Course deleted' })
  @ApiResponse({ status: 404, description: 'Course not found' })
  async remove(@Param('id', ParseBigIntPipe) id: bigint) {
    await this.coursesService.remove(id);
  }
}
