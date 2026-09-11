import { Controller, Get } from '@nestjs/common';
import { PrismaService } from './prisma/prisma.service';

@Controller()
export class AppController {
  constructor(private prisma: PrismaService) {}

  @Get('health')
  async health() {
    const userCount = await this.prisma.users.count();
    const courseCount = await this.prisma.courses.count();
    return { status: 'ok', userCount, courseCount };
  }
}