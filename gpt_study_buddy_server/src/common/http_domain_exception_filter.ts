import { Catch, ExceptionFilter, ArgumentsHost } from '@nestjs/common';
import { DomainError, DomainErrorType } from './domain_error';

@Catch(DomainError)
export class HttpDomainExceptionFilter implements ExceptionFilter {
  catch(exception: DomainError, host: ArgumentsHost) {
    console.log('HttpDomainExceptionFilter', exception);
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();
    const request = ctx.getRequest();

    let status = 900;
    switch (exception.type) {
      case DomainErrorType.BadRequest:
        status = 400;
        break;
      case DomainErrorType.Unauthorized:
        status = 401;
        break;
      case DomainErrorType.Forbidden:
        status = 403;
        break;
      case DomainErrorType.NotFound:
        status = 404;
        break;
      default:
        status = 500;
    }

    response.status(status).json({
      statusCode: status,
      timestamp: new Date().toISOString(),
      path: request.url,
      message: exception.message,
    });
  }
}
