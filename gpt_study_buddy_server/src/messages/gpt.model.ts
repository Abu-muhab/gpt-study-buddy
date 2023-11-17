export interface GptFunction {
  name: string;
  description: string;
  parameters?: object;
}

export abstract class GptFunctionHandler {
  abstract get handledFunctions(): GptFunction[];
  abstract handleFunction(params: {
    functionName: string;
    args: object;
  }): Promise<{
    result: string;
    createdResources: CompletionCreatedResource[];
  }>;
}

export enum CompletionCreatedResourceType {
  event = 'event',
  note = 'note',
  ppt = 'ppt',
}

export interface CompletionCreatedResource {
  type: CompletionCreatedResourceType;
  resource: Object;
}

export interface CompletionResult {
  completion: string;
  createdResources: CompletionCreatedResource[];
}
