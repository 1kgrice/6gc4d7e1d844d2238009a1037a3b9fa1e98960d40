import Axios, { AxiosInstance, AxiosResponse } from 'axios';
import { setupCache, CacheAxiosResponse } from 'axios-cache-interceptor';

interface RequestOptions {
  params?: Record<string, unknown>;
  headers?: Record<string, string>;
  raw?: boolean;
  cache?: Record<string, unknown>;
  id?: string | null;
}

class Api {
  private network: AxiosInstance
  private timeout: number;

  constructor() {
    this.network = this.setupInterceptors();
    this.timeout = 40 * 1000; // 40 seconds
  }

  private async performRequest(
    requestType: 'GET' | 'POST' | 'DELETE' | 'PATCH' | 'PUT',
    endPoint: string,
    { params = {}, headers = {}, raw = false, cache = {}, id = null }: RequestOptions = {}
  ): Promise<AxiosResponse | CacheAxiosResponse | any> {
    let defaultHeaders: Record<string, string> = { 'Content-Type': 'application/json' };

    try {
      const response = await this.network({
        method: requestType,
        url: endPoint,
        params: params,
        headers: { ...defaultHeaders, ...headers },
        timeout: this.timeout,
        cache: cache,
        id: id
      } as any);

      if (raw) {
        return response;
      } else {
        return response.data;
      }
    } catch (error) {
      return Promise.reject(error);
    }
  }

  private setupInterceptors(): AxiosInstance {
    const instance: AxiosInstance = Axios.create();
    const axios = setupCache(instance);

    axios.interceptors.request.use(
      (config) => {
        if (config.params) {
          // Filter out null, undefined (or any other falsy values)
          config.params = Object.entries(config.params)
            .filter(([_, value]) => value != null && value != '' && value != undefined)
            .reduce((acc, [key, value]) => ({ ...acc, [key]: value }), {});
        }
  
        config.timeout = this.timeout;
        return config;
      },
      (error) => Promise.reject(error)
    );
  

    axios.interceptors.response.use(
      (response) => response,
      (error) => Promise.reject(error)
    );

    return axios;
  }

  public async get(endPoint: string, options: RequestOptions = {}) {
    return this.performRequest('GET', endPoint, options);
  }

  public async post(endPoint: string, options: RequestOptions = {}) {
    return this.performRequest('POST', endPoint, options);
  }

  public async delete(endPoint: string, options: RequestOptions = {}) {
    return this.performRequest('DELETE', endPoint, options);
  }

  public async patch(endPoint: string, options: RequestOptions = {}) {
    return this.performRequest('PATCH', endPoint, options);
  }

  public async put(endPoint: string, options: RequestOptions = {}) {
    return this.performRequest('PUT', endPoint, options);
  }
}

const _API = new Api();

export default _API;