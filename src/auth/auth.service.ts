import { ForbiddenException, Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../prisma/prisma.service';
import { LoginDto } from './dto/login.dto';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwt: JwtService,
  ) {}

  async login(dto: LoginDto) {
    const user = await this.prisma.users.findFirst({
      where: { email: dto.email },
    });

    // Same message for both cases, so attackers can't tell which emails exist
    if (!user || !(await bcrypt.compare(dto.password, user.password_hash))) {
      throw new UnauthorizedException('Invalid email or password');
    }

    if (user.status !== 'ACTIVE') {
      throw new ForbiddenException('Account is not active');
    }

    // BigInt can't go inside a JWT, so convert the id to a string
    const payload = { sub: user.id.toString(), email: user.email, role: user.role };

    return {
      access_token: await this.jwt.signAsync(payload),
      user: {
        id: user.id.toString(),
        email: user.email,
        full_name: user.full_name,
        role: user.role,
      },
    };
  }
}
