// Copyright (C) 2024 Decentralized Consulting
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

// ----------------------------------------------------------------------------
// Imports
// ----------------------------------------------------------------------------
import {AxiosResponse, AxiosError } from 'axios'
import axios from 'axios'
import Game from './game'

export default class Service {

  public static SessionInitialize(
    success: (data: object) => void,
    error: (status: number | undefined, msg: string) => void)
  {
    axios({
      method: 'get',
      url: __SERVER__ + '/api/session/initialize/' + Game.Address(),
      withCredentials: true,
    })
    .then((rsp: AxiosResponse) => {
      success(rsp.data)
    })
    .catch((err: AxiosError) => {
      if(undefined != error){
        error(err.response?.status, err.message)
      }
    })
  }
}